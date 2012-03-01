require File.join(File.dirname(__FILE__), 'helper')

class TestFileRefProperties < Test::Unit::TestCase
  context "The crash.mp3 file audio properties" do
    setup do
      @fileref = TagLib::FileRef.new("test/data/crash.mp3", true, TagLib::AudioProperties::Average)
      @properties = @fileref.audio_properties
    end

    should "exist" do
      assert_not_nil @properties
    end

    should "contain basic information" do
      assert_equal 2, @properties.length
      assert_equal 157, @properties.bitrate
      assert_equal 44100, @properties.sample_rate
      assert_equal 2, @properties.channels
    end
  end
end
