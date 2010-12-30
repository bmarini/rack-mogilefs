require 'test_helper'

class TestReproxy < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
  end

  def test_reproxy
    @client.expects(:get_paths).with("/assets/image.png").returns( %w(/path/1.png /path/2.png) )

    app_with(
      :path     => %r{^/assets/*},
      :client   => @client,
      :strategy => :reproxy
    )

    get '/assets/image.png'
    assert_status 200
    assert_content_type "image/png"
    assert_equal_header "/reproxy", "X-Accel-Redirect"
    assert_equal_header "/path/1.png /path/2.png", "X-Reproxy-Url"
  end
end
