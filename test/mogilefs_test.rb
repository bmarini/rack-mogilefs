require 'test_helper'

class TestMiddleWare < Test::Unit::TestCase
  class MockMogileFsClient
    def get_file_data(key)
      "Mock Data for #{key}"
    end
  end

  def test_middleware_with_path
    app = Rack::Builder.new do
      use Rack::Lint
      use Rack::MogileFS, :path => %r{^/assets/*}
      use Rack::Lint
      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    end

    response = Rack::MockRequest.new(app).get('/')
    assert_equal "Hello, World!", response.body

    response = Rack::MockRequest.new(app).get('/assets/unreachable.txt')
    assert_equal "couldn't connect to mogilefsd backend", response.body
    assert_equal 503, response.status
  end

  def test_middleware_with_mock_mogile_client
    app = Rack::Builder.new do
      use Rack::Lint
      use Rack::MogileFS, :path => %r{^/assets/*}, :client => MockMogileFsClient.new
      use Rack::Lint
      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    end

    response = Rack::MockRequest.new(app).get('/')
    assert_equal "Hello, World!", response.body

    response = Rack::MockRequest.new(app).get('/assets/mocked.txt')
    assert_equal "Mock Data for /assets/mocked.txt", response.body
    assert_equal 200, response.status
    assert_equal "text/plain", response.headers['Content-Type']
  end
end
