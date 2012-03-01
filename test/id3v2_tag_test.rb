require File.join(File.dirname(__FILE__), 'helper')

class TestID3v2Tag < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      read_properties = false
      @file = TagLib::MPEG::File.new("test/data/sample.mp3", read_properties)
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

    teardown do
      @file.close
      @file = nil
    end
  end

  context "A new ID3v2::Tag" do
    setup do
      @tag = TagLib::ID3v2::Tag.new
    end

    should "be empty" do
      assert @tag.empty?
    end

    should "have nil for string attributes" do
      assert_nil @tag.title
      assert_nil @tag.artist
      assert_nil @tag.album
      assert_nil @tag.comment
      assert_nil @tag.genre
    end

    should "have 0 for numeric attributes" do
      assert_equal 0, @tag.track
      assert_equal 0, @tag.year
    end
  end
end
