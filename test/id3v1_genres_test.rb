require File.join(File.dirname(__FILE__), 'helper')

class TestVorbisTag < Test::Unit::TestCase
  context "TagLib::ID3v1" do
    should "list genres" do
      assert_equal "Jazz", TagLib::ID3v1::genre_list[8]
    end

    should "map genres to their index" do
      assert_equal 8, TagLib::ID3v1::genre_map["Jazz"]
    end

    should "support to query the value of a genre" do
      assert_equal "Jazz", TagLib::ID3v1::genre(8)
      assert_equal "", TagLib::ID3v1::genre(255)
    end

    should "support to query the index of a genre" do
      assert_equal 8, TagLib::ID3v1::genre_index("Jazz")
      assert_equal 255, TagLib::ID3v1::genre_index("Unknown")
    end
  end
end