require 'mogilefs'
require 'mime/types'

module Rack
  class MogileFS
    autoload :Endpoint, "rack/mogilefs/endpoint"

    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      if env['PATH_INFO'] =~ @options[:path]
        Endpoint.new(@options).call(env)
      else
        @app.call(env)
      end
    end
  end
end
