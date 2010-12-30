# rack-mogilefs

If you are using Nginx you'll probably want to serve MogileFS files with
the [MogileFS Module](http://www.grid.net.ru/nginx/mogilefs.en.html), but if
you need a quick way to serve them out of a Rack app, this should help.

## Getting Started:

First install the gem:

    gem install rack-mogilefs

There are a variety of ways to use it:

### Rails 3:

    # (config/routes.rb)
    match "/assets/*" => Rack::MogileFS::Endpoint.new

### Rails 2:

    # (app/metal/mogilefs_metal.rb)
    class MogilefsMetal
      def self.call(env)
        if env["PATH_INFO"] =~ %r{^/assets/*}
          Rack::MogileFS::Endpoint.new.call(env)
        else
          [ 404, { "Content-Type" => "text/html" }, ["Not Found"] ]
        end
      end
    end

### Rack middleware
    # (config.ru)
    use Rack::MogileFS, :path => %r{^/assets/*}

## File Lookup

`Rack::MogileFS` uses the request path (`PATH_INFO`) for the MogileFS key. The
content type of the file is detected by the extension, using the `mime-types`
gem.

If you want to customize the mapping of the PATH_INFO string to a MogileFS key
you can provide a mapper proc (or anything that responds to call) like this:

    # map '/assets/filename.gif' to the mogilefs key 'filename.gif'
    # Rack::MogileFS and Rack::MogileFS::Endpoint take the same options
    use Rack::MogileFS,
      :path   => %r{^/assets/*},
      :mapper => lambda { |path| path.sub('/assets/', '') }

## Configuration

If `Rack::MogileFS` detects it is inside a Rails app, it will look for a yaml
config in `config/mogilefs.yml` that looks like this:

    development:
      connection:
        domain: "development.myapp.com"
        hosts:
          - 127.0.0.1:7001
          - 127.0.0.1:7001
      class: "file"
    staging:
      ...


and initialize a MogileFS client like this:

    config = YAML.load_file( Rails.root.join("config/mogilefs.yml") )[Rails.env]
    MogileFS::MogileFS.new( config["connection"].symbolize_keys )

You can override this by passing in a MogileFS client of your own:

    Rack::MogileFS::Endpoint.new :client => MyMogileFSClient.new

## Caveats ( serving files vs reproxying )

Serving files through Ruby can be slow. `Rack::MogileFS` will read the entire
file into memory before sending it downstream. If you have varnish/squid/a CDN
sitting in front of rails then this isn't so problematic.

The preferred method is to set an X-Reproxy-Url header from your app and let
the web server serve the file instead of `Rack::MogileFS`. For Nginx, you
could have a config like this:

    location /reproxy {
        internal;
        set $reproxy $upstream_http_x_reproxy_url;
        proxy_pass $reproxy;
        proxy_hide_header Content-Type;
    }

For Apache, there is [mod_reproxy](http://github.com/jamis/mod_reproxy)

`Rack::MogileFS` will use this method if you pass a strategy option of `:reproxy`

    use Rack::MogileFS, :strategy => :reproxy

`Rack::MogileFS` will look up the internal urls for the file, and set two
headers to reproxy the request:

    X-Accel-Redirect: /reproxy
    X-Reproxy-Url: http://internal.ip/path/to/mogile/file.fid

You'll have to make sure your web server knows how to handle this request.

