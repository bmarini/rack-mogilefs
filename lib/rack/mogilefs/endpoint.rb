module Rack
  class MogileFS
    class Endpoint

      def initialize(options={})
        @options = {
          :client => nil,
          :default_content_type => "image/png"
        }.merge(options)

        @options[:client] ||= default_client
      end

      def call(env)
        data = client.get_file_data(env['PATH_INFO'])
        [ 200, { "Content-Type" => content_type(env['PATH_INFO']) }, [ data ] ]
      rescue ::MogileFS::Backend::UnknownKeyError
        [ 404, { "Content-Type" => "text/html" }, ["Not Found"] ]
      rescue ::MogileFS::UnreachableBackendError => e
        [ 503, { "Content-Type" => "text/html" }, [e.message] ]
      rescue ::MogileFS::Error => e
        [ 500, { "Content-Type" => "text/html" }, [e.message] ]
      end

      protected

      def content_type(path_info)
        ext = path_info.split(".").last
        MIME::Types.type_for(ext).first.content_type
      rescue
        @options[:default_content_type]
      end

      def client
        @options[:client]
      end

      def default_client
        ::MogileFS::MogileFS.new(config)
      end

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
