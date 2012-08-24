require File.join(File.dirname(__FILE__), 'helper')

class MP4FileTest < Test::Unit::TestCase
  context "TagLib::MP4::File" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
    end

    should "have a tag" do
      tag = @file.tag
      assert_not_nil tag
      assert_equal TagLib::Tag, tag.class
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
