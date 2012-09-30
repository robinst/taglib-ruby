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
      end

      should "exist" do
        assert_not_nil @item_list_map
      end

      should "not be empty" do
        assert_equal false, @item_list_map.empty?
      end

      should "contain 9 items" do
        assert_equal 9, @item_list_map.size
      end

      should "have keys" do
        ["\xa9nam", "\xa9ART", "\xa9alb", "\xa9cmt", "\xa9gen", "\xa9day",
         "trkn"].each do |key|
          assert_equal true, @item_list_map.contains?(key)
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end