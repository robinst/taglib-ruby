require File.join(File.dirname(__FILE__), 'helper')

class TestMPEGFile < Test::Unit::TestCase
  context "The crash.mp3 file" do
    setup do
      read_properties = true
      @file = TagLib::MPEG::File.new("test/data/crash.mp3", read_properties)
    end

    should "have a basic tag" do
      tag = @file.tag
      assert_not_nil tag
      assert_equal TagLib::Tag, tag.class
      assert tag.empty?
    end

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "be MPEG audio properties" do
        assert_equal TagLib::MPEG::Properties, @properties.class
      end

      should "contain information" do
        assert_equal 2, @properties.length_in_seconds
        assert_equal 2299, @properties.length_in_milliseconds
        assert_equal 157, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        assert_equal 2, @properties.channels
        assert_equal TagLib::MPEG::Header::Version1, @properties.version
        assert_equal 3, @properties.layer
        assert_equal false, @properties.protection_enabled
        assert_equal TagLib::MPEG::Header::JointStereo, @properties.channel_mode
        assert_equal false, @properties.copyrighted?
        assert_equal true, @properties.original?
      end

      context "Xing header" do
        setup do
          @xing_header = @properties.xing_header
        end

        should "exist" do
          assert_not_nil @xing_header
        end

        should "contain information" do
          assert @xing_header.valid?
          assert_equal 88, @xing_header.total_frames
          assert_equal 45140, @xing_header.total_size
          assert_equal TagLib::MPEG::XingHeader::Xing, @xing_header.type
        end
      end
    end

    should "have no tag" do
      refute @file.id3v1_tag?
      refute @file.id3v2_tag?
      refute @file.ape_tag?
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "The id3v1.mp3 file" do
    setup do
      read_properties = true
      @file = TagLib::MPEG::File.new("test/data/id3v1.mp3", read_properties)
    end

    should "have a basic tag" do
      tag = @file.tag
      assert_not_nil tag
      assert_equal TagLib::Tag, tag.class
      refute tag.empty?
    end

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "be MPEG audio properties" do
        assert_equal TagLib::MPEG::Properties, @properties.class
      end

      should "contain information" do
        assert_equal 0, @properties.length_in_seconds
        assert_equal 261, @properties.length_in_milliseconds
        assert_equal 141, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        assert_equal 2, @properties.channels
        assert_equal TagLib::MPEG::Header::Version1, @properties.version
        assert_equal 3, @properties.layer
        assert_equal false, @properties.protection_enabled
        assert_equal TagLib::MPEG::Header::JointStereo, @properties.channel_mode
        assert_equal false, @properties.copyrighted?
        assert_equal true, @properties.original?
      end

      context "Xing header" do
        setup do
          @xing_header = @properties.xing_header
        end

        should "exist" do
          assert_not_nil @xing_header
        end

        should "contain information" do
          assert @xing_header.valid?
          assert_equal 10, @xing_header.total_frames
          assert_equal 4596, @xing_header.total_size
          assert_equal TagLib::MPEG::XingHeader::Xing, @xing_header.type
        end
      end
    end

    context "tag" do
      setup do
        @tag = @file.tag
      end

      should "exist" do
        refute_nil @tag
        assert_equal TagLib::Tag, @tag.class
      end

      should "have basic properties" do
        refute @tag.empty?

        assert_equal 'Title', @tag.title
        assert_equal 'Artist', @tag.artist
        assert_equal 'Album', @tag.album
        assert_equal 'Comment', @tag.comment
        assert_equal 'Pop', @tag.genre
        assert_equal 2011, @tag.year
        assert_equal 7, @tag.track
      end
    end

    context "ID3V1 tag" do
      setup do
        @tag = @file.id3v1_tag(false)
      end

      should "exist" do
        assert @file.id3v1_tag?
        refute @file.id3v2_tag?
        refute @file.ape_tag?

        assert_not_nil @tag
        assert_equal TagLib::ID3v1::Tag, @tag.class
      end

      should "have basic properties" do
        refute @tag.empty?

        assert_equal 'Title', @tag.title
        assert_equal 'Artist', @tag.artist
        assert_equal 'Album', @tag.album
        assert_equal 'Comment', @tag.comment
        assert_equal 'Pop', @tag.genre
        assert_equal 2011, @tag.year
        assert_equal 7, @tag.track
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "TagLib::MPEG::File" do
    should "have open method" do
      title = nil
      TagLib::MPEG::File.open("test/data/sample.mp3", false) do |file|
        title = file.tag.title
      end
      assert_equal "Dummy Title", title
    end
  end
end
