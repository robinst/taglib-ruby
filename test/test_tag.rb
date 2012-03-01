require File.join(File.dirname(__FILE__), 'helper')

class TestTag < Test::Unit::TestCase
  context "The sample.mp3 file" do
    setup do
      @fileref = TagLib::FileRef.new("test/data/sample.mp3", false)
      @tag = @fileref.tag
    end

    should "have basic tag information" do
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
