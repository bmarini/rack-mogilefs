module Rack
  class MogileFS
    class Endpoint

      # Catches some potential MogileFS exceptions and will return sensible
      # HTTP status codes. You can disable with:
      #
      #     Rack::MogileFS::Endpoint.new :debug => true
      module Rescues
        def initialize(*)
          super
          @options[:debug] ||= false
        end

        def call(env)
          if @options[:debug]
            super
          else
            with_rescues { super }
          end
        end

        def with_rescues
          yield
        rescue ::MogileFS::Backend::UnknownKeyError => e
          [ 404, { "Content-Type" => "text/html" }, [e.message] ]
        rescue ::MogileFS::UnreachableBackendError => e
          [ 503, { "Content-Type" => "text/html" }, [e.message] ]
        rescue ::MogileFS::Error => e
          [ 500, { "Content-Type" => "text/html" }, [e.message] ]
        end
      end

    end
  end
end