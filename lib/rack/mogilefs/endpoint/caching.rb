module Rack
  class MogileFS
    class Endpoint

      # Adds support for expires headers. You can specify a number or a proc
      # that will recieve (path, ext, mime) as arguements. You should return
      # the number of seconds to cache.
      module Caching
        def initialize(*)
          super
          @options[:expires] ||= false
        end

        def headers(file)
          super.merge( cache_control_header(file) )
        end

        private

        def cache_control_header(file)
          if @options[:expires]
            { "Cache-Control" => "max-age=#{max_age(file)}, public" }
          else
            {}
          end
        end

        def max_age(file)
          if @options[:expires].respond_to?(:call)
            @options[:expires].call(file.path, file.extname, file.content_type)
          else
            @options[:expires]
          end
        end

      end

    end
  end
end
