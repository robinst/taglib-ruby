require File.join(File.dirname(__FILE__), 'helper')

class AIFFFileTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/aiff-sample.aiff"
  PICTURE_FILE = "test/data/globe_east_540.jpg"

  context "TagLib::RIFF::AIFF::File" do
    setup do
      @file = TagLib::RIFF::AIFF::File.new(SAMPLE_FILE)
      @tag = @file.tag
      File.open(PICTURE_FILE, "rb") do |f|
        @picture_data = f.read
      end
    end

    should "have an ID3v2 tag" do
      assert_not_nil @tag
      assert_equal TagLib::ID3v2::Tag, @tag.class
    end

    should "contain basic tag information" do
      assert_equal "AIFF Dummy Track Title - ID3v2.4", @tag.title
      assert_equal "AIFF Dummy Artist Name", @tag.artist
      assert_equal "AIFF Dummy Album Title", @tag.album
      assert_equal "AIFF Dummy Comment", @tag.comment
      assert_equal "Jazz", @tag.genre
      assert_equal 2014, @tag.year
      assert_equal 3, @tag.track
      assert_equal false, @tag.empty?
    end

    context "APIC frame" do
      setup do
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

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "exist" do
        assert_not_nil @properties
      end

      should "contain basic information" do
        assert_equal 2, @properties.length
        assert_equal 256, @properties.bitrate
        assert_equal 8000, @properties.sample_rate
        assert_equal 2, @properties.channels
      end

      should "contain AIFF-specific information" do
        assert_equal 16, @properties.sample_width
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "TagLib::RIFF::AIFF::File.open" do
    should "have open method" do
      title = nil
      TagLib::RIFF::AIFF::File.open(SAMPLE_FILE, false) do |file|
        title = file.tag.title
      end
      assert_equal "AIFF Dummy Track Title - ID3v2.4", title
    end
  end

end
