require 'mogilefs'
require 'rack/mime'
require 'rack/utils'

module Rack
  class MogileFS
    autoload :Endpoint, "rack/mogilefs/endpoint"
    autoload :Version, "rack/mogilefs/version"

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
