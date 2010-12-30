require 'test_helper'

class TestMiddleWare < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
  end

  def test_path_matching
    app_with :path => %r{^/assets/*}
    get '/'

    assert_body "Hello, World!"
  end

  def test_middleware_with_mock_mogile_client
    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/asset.txt'

    assert_body "Mock Data for /assets/asset.txt"
  end

end
