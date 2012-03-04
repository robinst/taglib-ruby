require File.join(File.dirname(__FILE__), 'helper')

class TestVorbisFile < Test::Unit::TestCase
  context "The vorbis.oga file" do
    setup do
      @file = TagLib::Ogg::Vorbis::File.new("test/data/vorbis.oga")
    end

    should "have a tag" do
      tag = @file.tag
      assert_not_nil tag
      assert_equal TagLib::Ogg::XiphComment, tag.class
    end

    context "audio properties" do
      setup do
        @properties = @file.audio_properties
      end

      should "exist" do
        assert_not_nil @properties
      end

      should "contain basic information" do
        assert_equal 0, @properties.length # file is short
        assert_equal 64, @properties.bitrate
        assert_equal 44100, @properties.sample_rate
        assert_equal 2, @properties.channels
      end

      should "contain vorbis-specific information" do
        assert_equal 0, @properties.vorbis_version
        assert_equal 0, @properties.bitrate_maximum
        assert_equal 64000, @properties.bitrate_nominal
        assert_equal 0, @properties.bitrate_minimum
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "TagLib::Ogg::Vorbis::File" do
    should "have open method" do
      title = nil
      TagLib::Ogg::Vorbis::File.open("test/data/vorbis.oga", false) do |file|
        title = file.tag.title
      end
      assert_equal "Title", title
    end
  end
end
