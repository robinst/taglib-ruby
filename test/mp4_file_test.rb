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

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "exist" do
        assert_not_nil @properties
      end

      should "contain basic information" do
        assert_equal 1, @properties.length
        assert_equal 54, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        # The test file is mono, this appears to be a TagLib bug
        assert_equal 2, @properties.channels
      end

      should "contain mp4-specific information" do
        assert_equal 16, @properties.bits_per_sample
        # Properties#encrypted? raises a NoMethodError
        # assert_equal false, @properties.encrypted?
      end
    end

    context "item_list_map" do
      setup do
        @item_list_map = @file.tag.item_list_map
        @item_keys = [
          "\u00A9nam", "\u00A9ART", "\u00A9alb", "\u00A9cmt", "\u00A9gen",
          "\u00A9day", "trkn", "\u00A9too", "\u00A9cpy"
        ]
      end

      should "exist" do
        assert_not_nil @item_list_map
      end

      should "not be empty" do
        assert_equal false, @item_list_map.empty?
      end

      should "contain 9 items" do
        assert_equal @item_keys.count, @item_list_map.size
      end

      should "have keys" do
        assert_equal true, @item_list_map.contains("trkn")
        assert_equal true, @item_list_map.has_key?("\u00A9too")
        assert_equal true, @item_list_map.include?("\u00A9cpy")
        assert_equal false, @item_list_map.include?("none such key")
      end

      should "look up keys" do
        assert_nil @item_list_map["none such key"]
        assert_equal "Title", @item_list_map["\u00A9nam"]
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
