require File.join(File.dirname(__FILE__), 'helper')

class FlacFileTest < Test::Unit::TestCase
  context "TagLib::FLAC::File" do
    setup do
      @file = TagLib::FLAC::File.new("test/data/flac.flac")
    end

    should "have a tag" do
      tag = @file.tag
      assert_not_nil tag
      assert_equal TagLib::Tag, tag.class
    end

    should "have XiphComment" do
      assert @file.xiph_comment?
      tag = @file.xiph_comment
      assert_not_nil tag
      assert_equal TagLib::Ogg::XiphComment, tag.class
    end

    should "have method for ID3v1 tag" do
      refute @file.id3v1_tag?
      assert_nil @file.id3v1_tag
    end

    should "have method for ID3v2 tag" do
      refute @file.id3v2_tag?
      assert_nil @file.id3v2_tag
    end

    should "support stripping tags by type" do
      @file.strip(TagLib::FLAC::File::XiphComment)
      assert @file.xiph_comment?
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
        assert_equal 1017, @properties.length_in_milliseconds
        assert_equal 209, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        assert_equal 1, @properties.channels
      end

      should "contain flac-specific information" do
        assert_equal 16, @properties.bits_per_sample
        s = ["78d19b86df2cd488b35957e6bd884968"].pack('H*')
        assert_equal s, @properties.signature
      end
    end

    should "have pictures" do
      refute_empty @file.picture_list
    end

    context "first picture" do
      setup do
        @picture = @file.picture_list.first
      end

      should "be a TagLib::FLAC::Picture," do
        assert_equal TagLib::FLAC::Picture, @picture.class
      end

      should "have meta-data" do
        assert_equal TagLib::FLAC::Picture::FrontCover, @picture.type
        assert_equal "image/jpeg", @picture.mime_type
        assert_equal "Globe", @picture.description
        assert_equal 90, @picture.width
        assert_equal 90, @picture.height
        assert_equal 8, @picture.color_depth
        assert_equal 0, @picture.num_colors
      end

      should "have data" do
        picture_data = File.open("test/data/globe_east_90.jpg", 'rb'){ |f| f.read }
        assert_equal picture_data, @picture.data
      end
    end

    should "support removing a picture" do
      refute_empty @file.picture_list
      @file.remove_picture(@file.picture_list.first)
      assert_empty @file.picture_list
    end

    should "support removing all pictures" do
      refute_empty @file.picture_list
      @file.remove_pictures()
      assert_empty @file.picture_list
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "TagLib::FLAC::File.open" do
    should "should work" do
      title = nil
      TagLib::FLAC::File.open("test/data/flac.flac", false) do |file|
        title = file.tag.title
      end
      assert_equal "Title", title
    end
  end
end
