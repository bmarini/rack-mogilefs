require 'mogilefs'
require 'rack/mime'
require 'rack/utils'

module Rack
  class MogileFS
    autoload :Endpoint, "rack/mogilefs/endpoint"

    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      if env['PATH_INFO'] =~ @options[:path]
        endpoint.call(env)
      else
        @app.call(env)
      end
    end

    def endpoint
      @endpoint ||= Endpoint.new(@options)
    end
  end
end


# module Rack
#   class MyMogileFS
#     include Rack::MogileFS::Base
#     include Rack::MogileFS::ContentType
#     include Rack::MogileFS::Caching
#     include Rack::MogileFS::Reproxy
#   end
# end

# module Rack
#   class CachedMogileFS
#     def self.call(env)
#       status, headers, body = Rack::MogileFS::Endpoint.new.call(env)
#       # status, headers, body = [ 200, {"Content-Type" => "text/html"}, ["Hello"] ]
# 
#       if status == 200
#         headers.merge!("Cache-Control" => "max-age=#{1.month}, public")
#       end
# 
#       [ status, headers, body ]
#     end
#   end
# end
