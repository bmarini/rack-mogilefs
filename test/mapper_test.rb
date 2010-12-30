require 'test_helper'

class TestMapper < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
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
