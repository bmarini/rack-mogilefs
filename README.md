# Rack middleware/endpoint for serving MogileFS files

## Examples:

### Rack middleware
    # (config.ru)
    use Rack::MogileFS, :path => %r{^/system/*}

### Rails 3:

    # (config/routes.rb)
    match "/system/*" => Rack::MogileFS::Endpoint.new

### Rails 2:

    # (app/metal/mogilefs.rb)
    class MogileFSMetal
      def self.call(env)
        if env["PATH_INFO"] =~ %r{^/system/*}
          Rack::MogileFS::Endpoint.new.call(env)
        else
          [ 404, { "Content-Type" => "text/html" }, ["Not Found"] ]
        end
      end
    end

## Configuration

By default will look for a yaml config in `config/mogilefs.yml` that looks
like this:

    development:
      connection:
        domain: "development.myapp.com"
        hosts:
          - 127.0.0.1:7001
          - 127.0.0.1:7001
      class: "file"
    staging:
      ...


and initialize a mogilefs client like this:

    config = YAML.load_file( Rails.root.join("config/mogilefs.yml") )[Rails.env]
    MogileFS::MogileFS.new( config["connection"].symbolize_keys )

You can override this by passing in a MogileFS client of your own:

    Rack::MogileFS::Endpoint.new :client => MyMogileFSClient.new
    