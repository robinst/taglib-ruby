# frozen-string-literal: true

require File.join(File.dirname(__FILE__), 'helper')

class WAVFileWriteTest < Test::Unit::TestCase
  SAMPLE_FILE = 'test/data/wav-sample.wav'
  OUTPUT_FILE = 'test/data/_output.wav'
  PICTURE_FILE = 'test/data/globe_east_90.jpg'

  def reloaded(&block)
    TagLib::RIFF::WAV::File.open(OUTPUT_FILE, false, &block)
  end

  context 'TagLib::RIFF::WAV::File' do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::RIFF::WAV::File.new(OUTPUT_FILE, false)
    end

    should 'be able to save the title' do
      tag = @file.tag
      assert_not_nil tag
      tag.title = 'New Title'
      success = @file.save
      assert success
      @file.close
      @file = nil

      written_title = reloaded do |file|
        file.tag.title
      end
      assert_equal 'New Title', written_title
    end

    should 'have one picture frame' do
      assert_equal 2, @file.id3v2_tag.frame_list('APIC').size
    end

    should 'be able to remove all picture frames' do
      @file.id3v2_tag.remove_frames('APIC')
      success = @file.save
      assert success
      @file.close
      @file = nil

      reloaded do |file|
        assert_equal 0, file.id3v2_tag.frame_list('APIC').size
      end
    end

    should 'be able to add a picture frame' do
      picture_data = File.open(PICTURE_FILE, 'rb') { |f| f.read }

      apic = TagLib::ID3v2::AttachedPictureFrame.new
      apic.mime_type = 'image/jpeg'
      apic.description = 'desc'
      apic.text_encoding = TagLib::String::UTF8
      apic.picture = picture_data
      apic.type = TagLib::ID3v2::AttachedPictureFrame::BackCover

      @file.id3v2_tag.add_frame(apic)
      success = @file.save
      assert success
      @file.close
      @file = nil

      reloaded do |file|
        assert_equal 3, file.id3v2_tag.frame_list('APIC').size
      end

      reloaded do |file|
        written_apic = file.id3v2_tag.frame_list('APIC')[2]
        assert_equal 'image/jpeg', written_apic.mime_type
        assert_equal 'desc', written_apic.description
        assert_equal picture_data, written_apic.picture
      end
    end

    teardown do
      if @file
        @file.close
        @file = nil
      end
      FileUtils.rm OUTPUT_FILE
    end
  end

  context 'TagLib::RIFF::WAV::File.strip' do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::RIFF::WAV::File.new(OUTPUT_FILE)
    end

    should 'update the file immediately' do
      assert @file.id3v2_tag?

      @file.strip(TagLib::RIFF::WAV::File::ID3v2)

      reloaded do |_file|
        refute @file.id3v2_tag?
      end
    end

    teardown do
      if @file
        @file.close
        @file = nil
      end
      FileUtils.rm OUTPUT_FILE
    end
  end
end
