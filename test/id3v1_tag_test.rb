require File.join(File.dirname(__FILE__), 'helper')

class TestID3v1Tag < Test::Unit::TestCase
  context "The id3v1.mp3 file" do
    setup do
      read_properties = false
      @file = TagLib::MPEG::File.new("test/data/id3v1.mp3", read_properties)
    end

    should "have an ID3v1 tag" do
      assert_not_nil @file.id3v1_tag
    end

    context "ID3v1 tag" do
      setup do
        @tag = @file.id3v1_tag
      end

      should "have basic properties" do
        assert_equal 'Title', @tag.title
        assert_equal 'Artist', @tag.artist
        assert_equal 'Album', @tag.album
        assert_equal 'Comment', @tag.comment
        assert_equal 'Pop', @tag.genre
        assert_equal 2011, @tag.year
        assert_equal 7, @tag.track
        assert_equal false, @tag.empty?
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
