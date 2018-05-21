require File.join(File.dirname(__FILE__), 'helper')

class MP4FileTest < Test::Unit::TestCase
  context "TagLib::MP4::File" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
      @tag = @file.tag
    end

    should "have an MP4 tag" do
      assert @file.mp4_tag?
      refute_nil @tag
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

    should "support testing for the presence of items" do
      refute @tag.contains "unknown"
      assert @tag.contains "trkn"
    end

    should "support accessing items" do
      refute @tag["unkn"].valid?

      assert @tag["trkn"].valid?
      assert_equal 7, @tag.track
    end

    should "support editing items" do
      @tag["trkn"] = TagLib::MP4::Item.from_int(1)
      assert_equal 1, @tag.track
    end

    should "support removing items" do
      assert @tag.contains "trkn"
      @tag.remove_item("trkn")
      refute @tag.contains "trkn"
    end

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "exist" do
        assert_not_nil @properties
      end

      should "contain basic information" do
        assert_equal 1, @properties.length_in_seconds
        assert_equal 55, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        # The test file is mono, this appears to be a TagLib bug
        assert_equal 2, @properties.channels
      end

      should "contain mp4-specific information" do
        assert_equal 16, @properties.bits_per_sample
        assert_equal false, @properties.encrypted?
        assert_equal TagLib::MP4::Properties::AAC, @properties.codec
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
