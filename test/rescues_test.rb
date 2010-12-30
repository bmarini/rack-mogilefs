require 'test_helper'

class TestRescues < Test::Unit::TestCase
  def setup
    @client = MockMogileFsClient.new
  end

  def test_debug_mode
    app_with :path => %r{^/assets/*}, :debug => true
    assert_raises(MogileFS::UnreachableBackendError) do
      get '/assets/unreachable.txt'
    end
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

end
