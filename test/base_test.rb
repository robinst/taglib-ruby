require File.join(File.dirname(__FILE__), 'helper')

class BaseTest < Test::Unit::TestCase
  context "TagLib" do
    should "contain version constants" do
      assert TagLib::TAGLIB_MAJOR_VERSION.is_a? Integer
      assert TagLib::TAGLIB_MINOR_VERSION.is_a? Integer
      assert TagLib::TAGLIB_PATCH_VERSION.is_a? Integer
    end
  end
end
