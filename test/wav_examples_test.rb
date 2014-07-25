require File.join(File.dirname(__FILE__), 'helper')

class WAVExemples < Test::Unit::TestCase

  DATA_FILE_PREFIX = "test/data/wav-"

  context "TagLib::RIFF::WAV::File" do

    should "Run TagLib::RIFF::WAV::File examples" do


      # Reading the title

      title = TagLib::RIFF::WAV::File.open("#{DATA_FILE_PREFIX}sample.wav") do |file|
        file.tag.title
      end

      # Reading WAV-specific audio properties

      TagLib::RIFF::WAV::File.open("#{DATA_FILE_PREFIX}sample.wav") do |file|
        file.audio_properties.sample_width  #=>  8
      end

      # Saving ID3v2 cover-art to disk

      TagLib::RIFF::WAV::File.open("#{DATA_FILE_PREFIX}sample.wav") do |file|
        id3v2_tag = file.tag
        cover = id3v2_tag.frame_list('APIC').first
        ext = cover.mime_type.rpartition('/')[2]
        File.open("#{DATA_FILE_PREFIX}cover-art.#{ext}", "wb") { |f| f.write cover.picture }
      end


      # checks
      assert_equal "WAV Dummy Track Title", title
      assert_equal true, File.exist?("#{DATA_FILE_PREFIX}cover-art.jpeg")
      FileUtils.rm("#{DATA_FILE_PREFIX}cover-art.jpeg")
    end

  end

end
