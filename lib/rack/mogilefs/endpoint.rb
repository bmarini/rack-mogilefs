require 'rack/mogilefs/endpoint/base'
require 'rack/mogilefs/endpoint/client'
require 'rack/mogilefs/endpoint/mapper'
require 'rack/mogilefs/endpoint/rescues'
require 'rack/mogilefs/endpoint/reproxy'

module Rack
  class MogileFS
    class Endpoint
      include Base
      include Client
      include Mapper
      include Reproxy
      include Rescues
    end
  end
end
