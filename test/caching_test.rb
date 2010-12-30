require 'test_helper'

class TestCaching < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
  end

  def test_expires_with_int
    @client.expects(:get_file_data).with("/assets/image.png").returns("")

    app_with(
      :path    => %r{^/assets/*},
      :client  => @client,
      :expires => 300
    )

    get '/assets/image.png'
    assert_status 200
    assert_cache_control "max-age=300, public"
  end

  def test_expires_with_lambda
    @client.expects(:get_file_data).with("/assets/image.jpg").returns("")
  
    app_with(
      :path    => %r{^/assets/*},
      :client  => @client,
      :expires => lambda { |path, ext, mime|
        mime == "image/jpeg" ? 600 : 300
      }
    )
  
    get '/assets/image.jpg'
    assert_status 200
    assert_cache_control "max-age=600, public"
  end

end
