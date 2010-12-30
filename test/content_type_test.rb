require 'test_helper'

class TestContentType < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
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

end
