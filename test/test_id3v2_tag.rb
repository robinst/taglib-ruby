require 'helper'

class TestID3v2Tag < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      read_properties = false
      file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
      @file = file
    end

    should "have an ID3v2 tag" do
      assert_not_nil @file.id3v2_tag
    end

    context "tag" do
      setup do
        @tag = @file.id3v2_tag
      end

      should "have basic properties" do
        assert_equal 'Dummy Title', @tag.title
        assert_equal 'Dummy Artist', @tag.artist
        assert_equal 'Dummy Album', @tag.album
        assert_equal 'Dummy Comment', @tag.comment
        assert_equal 'Pop', @tag.genre
        assert_equal 2000, @tag.year
        assert_equal 1, @tag.track
        assert_equal false, @tag.empty?
      end
    end
  end
end
