require File.join(File.dirname(__FILE__), 'helper')

class WAVFileTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/wav-sample.wav"
  PICTURE_FILE = "test/data/globe_east_540.jpg"

  context "TagLib::RIFF::WAV::File" do
    setup do
      @file = TagLib::RIFF::WAV::File.new(SAMPLE_FILE)
    end

    should "open" do
      assert_not_nil @file
    end

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "exist" do
        assert_not_nil @properties
      end

      should "contain basic information" do
        assert_equal 0, @properties.length_in_seconds
        assert_equal 698, @properties.length_in_milliseconds
        assert_equal 88, @properties.bitrate
        assert_equal 11025, @properties.sample_rate
        assert_equal 1, @properties.channels
      end

      should "contain WAV-specific information" do
        assert_equal 8, @properties.bits_per_sample
        assert_equal TagLib::RIFF::WAV::FORMAT_PCM, @properties.format
      end
    end

    context "ID3V2 tag" do
      setup do
        @tag = @file.tag
      end

      should "exist" do
        assert @file.id3v2_tag?
        assert_not_nil @tag
        assert_equal TagLib::ID3v2::Tag, @tag.class
      end

      should "not have an Info tag" do
        refute @file.info_tag?
      end

      should "contain basic tag information" do
        assert_equal "WAV Dummy Track Title", @tag.title
        assert_equal "WAV Dummy Artist Name", @tag.artist
        assert_equal "WAV Dummy Album Title", @tag.album
        assert_equal "WAV Dummy Comment", @tag.comment
        assert_equal "Jazz", @tag.genre
        assert_equal 2014, @tag.year
        assert_equal 5, @tag.track
        assert_equal false, @tag.empty?
      end

      context "APIC frame" do
        setup do
          @picture_data = File.open(PICTURE_FILE, 'rb') { |f| f.read }
          @apic = @tag.frame_list('APIC').first
        end

        should "exist" do
          assert_not_nil @apic
          assert_equal TagLib::ID3v2::AttachedPictureFrame, @apic.class
        end

        should "have a type" do
          assert_equal TagLib::ID3v2::AttachedPictureFrame::FrontCover, @apic.type
        end

        should "have a mime type" do
          assert_equal "image/jpeg", @apic.mime_type
        end

        should "have picture bytes" do
          assert_equal 61649, @apic.picture.size
          assert_equal @picture_data, @apic.picture
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "TagLib::RIFF::WAV::File.open" do
    should "have open method" do
      title = nil
      TagLib::RIFF::WAV::File.open(SAMPLE_FILE, false) do |file|
        title = file.tag.title
      end
      assert_equal "WAV Dummy Track Title", title
    end
  end

end
