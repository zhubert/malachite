require 'test_helper'

class FileCompilerTest < MiniTest::Unit::TestCase
  def setup
    @source = Malachite::FileCompiler.new(File.expand_path('../fixtures/upcase.go', __FILE__)).compile
    @valid = File.expand_path('../fixtures/valid_upcase.go', __FILE__)
  end

  def test_confirm_compilation_matches_fixture
    compiled = File.read(Rails.root.join('tmp', 'upcase.go')).to_s
    assert_equal compiled, File.read(@valid).to_s
  end
end
