module Rack
  class MogileFS
    class Endpoint

      # Provides a default client if one is not passed in a a param. It is
      # recommended to use the default client if you can
      module Client
        def initialize(*)
          super
          @options[:client] ||= lambda { default_client }
        end

        def default_client
          ::MogileFS::MogileFS.new(config)
        end

        # If `Rack::MogileFS` detects it is inside a Rails app, it will look
        # for a yaml config in `config/mogilefs.yml` that looks like this:
        # 
        #     development:
        #       connection:
        #         domain: "development.myapp.com"
        #         hosts:
        #           - 127.0.0.1:7001
        #           - 127.0.0.1:7001
        #       class: "file"
        #     staging:
        #       ...
        def config
          if defined?(Rails)
            yml = YAML.load_file( Rails.root.join("config/mogilefs.yml") )
            yml[Rails.env]["connection"].symbolize_keys
          else
            { :domain => "default", :hosts => ["127.0.0.1:7001"] }
          end
        end
      end

    end
  end
end
