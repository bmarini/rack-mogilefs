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

  def test_unreachable_exception
    app_with :path => %r{^/assets/*}
    get '/assets/unreachable.txt'

    assert_status 503
    assert_body "couldn't connect to mogilefsd backend"
  end

  def test_unknown_key_exception
    @client.expects(:get_file_data).raises(MogileFS::Backend::UnknownKeyError)

    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/unknown.txt'

    assert_status 404
  end

  def test_mogilefs_exception
    @client.expects(:get_file_data).raises(MogileFS::Error)

    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/error.txt'

    assert_status 500
  end

  def test_middleware_with_mock_mogile_client
    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/asset.txt'

    assert_body "Mock Data for /assets/asset.txt"
  end

  def test_content_type_lookup
    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/asset.txt'

    assert_status 200
    assert_content_type "text/plain"

    get '/assets/asset.png'

    assert_status 200
    assert_content_type "image/png"

    get '/assets/asset.xml'

    assert_status 200
    assert_content_type "application/xml"
  end

  def test_default_content_type
    app_with :path => %r{^/assets/*}, :client => @client
    get '/assets/asset.xxx'

    assert_status 200
    assert_content_type "image/png"
  end

  def test_custom_key_mapping
    @client.expects(:get_file_data).with("image.png").returns("")
    app_with(
      :path   => %r{^/assets/*},
      :client => @client,
      :mapper => lambda { |p| p.sub('/assets/', '') }
    )

    get '/assets/image.png'
  end

end
