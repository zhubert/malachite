require 'test_helper'

# Not really a performance test, but designed to generate more work
class PerformanceTest < MiniTest::Test
  def test_confirm_compilation_matches_fixture
    1000.times do
      @client = Malachite::Client.new('upcase', ['foo'])
      assert_equal @client.call, ['FOO']
    end
  end
end
