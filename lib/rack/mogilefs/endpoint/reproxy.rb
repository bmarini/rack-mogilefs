module Rack
  class MogileFS
    class Endpoint

      # Adds reproxy support. To activate:
      #
      #     Rack::MogileFS::Endpoint.new :strategy => :reproxy
      module Reproxy
        def initialize(*)
          super
          @options[:strategy] ||= :serve
        end

        def serve_file(path)
          if @options[:strategy] == :reproxy
            reproxy(path)
          else
            super
          end
        end

        def reproxy(path)
          paths = client.get_paths(path)
          file  = File.new(path, nil)

          [ 200, {
            "Content-Type"     => file.content_type,
            "X-Accel-Redirect" => "/reproxy",
            "X-Reproxy-Url"    => paths.join(" ")
          }, [] ]
        end
      end

    end
  end
end