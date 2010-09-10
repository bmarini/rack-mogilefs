require "rubygems"
require "test/unit"
require "rack"
require "rack/mock"
require "mocha"
require "rack/mogilefs"

class MockMogileFsClient
  def get_file_data(key)
    "Mock Data for #{key}"
  end
end

class Test::Unit::TestCase
  def app_with(*args)
    @app = Rack::Builder.new do
      use Rack::Lint
      use Rack::MogileFS, *args
      use Rack::Lint
      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    end
  end

  def get(path)
    @response = Rack::MockRequest.new(@app).get(path)
  end

  def assert_body(body)
    assert_equal body, @response.body
  end

  def assert_status(code)
    assert_equal code, @response.status
  end

  def assert_content_type(content_type)
    assert_equal content_type, @response.headers["Content-Type"]
  end
end