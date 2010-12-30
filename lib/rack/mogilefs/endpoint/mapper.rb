module Rack
  class MogileFS
    class Endpoint

      # Adds ability to pass in a custom mapper to map PATH_INFO to a
      # MogileFS key. By default it is assumed that the path is the same as
      # the key. For example your keys will look like this:
      #
      #     "/assets/images/myimage.gif"
      #
      # Create a custom mapper like this:
      #
      #     Rack::MogileFS::Endpoint.new(
      #       :mapper => lambda { |path| "/namespace/" + path }
      #     )
      module Mapper
        def key_for_path(path)
          @options[:mapper].respond_to?(:call) ?
          @options[:mapper].call(path) : super
        end
      end

    end
  end
end
