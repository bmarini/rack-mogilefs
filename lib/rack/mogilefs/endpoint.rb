require 'rack/mogilefs/endpoint/base'
require 'rack/mogilefs/endpoint/caching'
require 'rack/mogilefs/endpoint/client'
require 'rack/mogilefs/endpoint/mapper'
require 'rack/mogilefs/endpoint/reproxy'
require 'rack/mogilefs/endpoint/rescues'

module Rack
  class MogileFS
    class Endpoint

      class File
        attr_accessor :path, :data

        def initialize(path, data)
          @path, @data = path, data
        end

        def extname
          ::File.extname(@path)
        end

        def length
          Utils.bytesize(@data).to_s
        end

        def content_type(default=nil)
          Mime.mime_type(extname, default)
        end
      end

      include Base
      include Client
      include Caching
      include Mapper
      include Reproxy
      include Rescues
    end
  end
end
