module Rack
  class MogileFS
    class Endpoint

      # This contains the base functionality for serving a MogileFS file. Most
      # of the useful stuff is layered on top the base class in other modules
      module Base
        def initialize(options={})
          @options = {
            :default_content_type => "image/png"
          }.merge(options)
        end

        def call(env)
          path = key_for_path( env['PATH_INFO'].dup )
          serve_file(path)
        end

        protected

        def serve_file(path)
          data = client.get_file_data(path)
          file = File.new(path, data)

          [ 200, headers(file), [data] ]
        end

        def client
          @client ||= begin
            @options[:client].respond_to?(:call) ? @options[:client].call : @options[:client]
          end
        end

        def key_for_path(path)
          path
        end

        def headers(file)
          {
            "Content-Type"   => file.content_type(@options[:default_content_type]),
            "Content-Length" => file.length
          }
        end

      end

    end
  end
end
