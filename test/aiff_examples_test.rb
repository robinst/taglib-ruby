require File.join(File.dirname(__FILE__), 'helper')

class AIFFExemples < Test::Unit::TestCase

  DATA_FILE_PREFIX = "test/data/aiff-"

  context "TagLib::RIFF::AIFF::File" do

    should "Run TagLib::RIFF::AIFF::File examples" do


      # @example Reading the title
      title = TagLib::RIFF::AIFF::File.open("#{DATA_FILE_PREFIX}sample.aiff") do |file|
        file.tag.title
      end

      # @example Reading AIFF-specific audio properties
      TagLib::RIFF::AIFF::File.open("#{DATA_FILE_PREFIX}sample.aiff") do |file|
        file.audio_properties.sample_width  #=>  16
      end

      # @example Saving ID3v2 cover-art to disk
      TagLib::RIFF::AIFF::File.open("#{DATA_FILE_PREFIX}sample.aiff") do |file|
        id3v2_tag = file.tag
        cover = id3v2_tag.frame_list('APIC').first
        ext = cover.mime_type.rpartition('/')[2]
        File.open("#{DATA_FILE_PREFIX}cover-art.#{ext}", "wb") { |f| f.write cover.picture }
      end


      # checks
      assert_equal "AIFF Dummy Track Title - ID3v2.4", title
      assert_equal true, File.exist?("#{DATA_FILE_PREFIX}cover-art.jpeg")
      FileUtils.rm("#{DATA_FILE_PREFIX}cover-art.jpeg")
    end

  end

end
