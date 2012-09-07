require File.join(File.dirname(__FILE__), 'helper')

class MP4FileTest < Test::Unit::TestCase
  context "TagLib::MP4::File" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
      @tag = @file.tag
    end

    should "contain basic tag information" do
      assert_equal "Title", @tag.title
      assert_equal "Artist", @tag.artist
      assert_equal "Album", @tag.album
      assert_equal "Comment", @tag.comment
      assert_equal "Pop", @tag.genre
      assert_equal 2011, @tag.year
      assert_equal 7, @tag.track
      assert_equal false, @tag.empty?
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
