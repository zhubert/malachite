require 'test_helper'

class ClientTest < MiniTest::Unit::TestCase
  def setup
    @client = Malachite::Client.new('upcase', ['foo'])
  end

  def test_confirm_compilation_matches_fixture
    assert_equal @client.call, ['FOO']
  end
end
