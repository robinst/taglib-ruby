require File.join(File.dirname(__FILE__), 'helper')

require 'fileutils'

class TestID3v2Write < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/sample.mp3"
  OUTPUT_FILE = "test/data/output.mp3"
  PICTURE_FILE = "test/data/globe_east_540.jpg"

  def reloaded
    TagLib::MPEG::File.open(OUTPUT_FILE, false) do |file|
      yield file
    end
  end

  context "TagLib::MPEG::File" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::MPEG::File.new(OUTPUT_FILE, false)
    end

    should "be able to strip the tag" do
      assert_not_nil @file.id3v2_tag
      success = @file.strip
      assert success
      assert_nil @file.id3v2_tag
      @file.close
      @file = nil

      reloaded do |file|
        assert_equal true, file.id3v1_tag.empty?
        assert_equal true, file.id3v2_tag.empty?
      end
    end

    should "be able to save only ID3v2 tag" do
      assert_not_nil @file.id3v2_tag
      assert_not_nil @file.id3v1_tag
      @file.save(TagLib::MPEG::File::ID3v2)
      @file.close
      @file = nil

      reloaded do |file|
        id3v1_tag = file.id3v1_tag
        id3v2_tag = file.id3v2_tag

        # TagLib always creates the tags
        assert_not_nil id3v1_tag
        assert_not_nil id3v2_tag

        assert_equal true, file.id3v1_tag.empty?
        assert_equal false, file.id3v2_tag.empty?
      end
    end

    should "be able to save ID3v2.3" do
      success = @file.save(TagLib::MPEG::File::ID3v2, true, 3)
      assert_equal true, success
      @file.close
      @file = nil

      header = File.open(OUTPUT_FILE, 'rb') do |f|
        f.read(5)
      end
      # 3 stands for v2.3
      s = "ID3" + 3.chr + 0.chr
      assert_equal s, header
    end

    should "be able to set fields to nil" do
      tag = @file.id3v2_tag
      tag.title = nil
      assert_equal [], tag.frame_list('TIT2')
    end

    context "with a fresh tag" do
      setup do
        @file.strip
        @tag = @file.id3v2_tag(true)
      end

      should "be able to create a new tag" do
        assert_not_nil @tag
        assert_equal 0, @tag.frame_list.size
      end

      should "be able to save it" do
        success = @file.save
        assert success
      end

      should "be able to add a new frame to it and read it back" do
        picture_data = File.open(PICTURE_FILE, 'rb') { |f| f.read }

        apic = TagLib::ID3v2::AttachedPictureFrame.new
        apic.mime_type = "image/jpeg"
        apic.description = "desc"
        apic.text_encoding = TagLib::String::UTF8
        apic.picture = picture_data
        apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover

        @tag.add_frame(apic)

        success = @file.save
        assert success
        @file.close
        @file = nil

        written_file = TagLib::MPEG::File.new(OUTPUT_FILE, false)
        written_apic = written_file.id3v2_tag.frame_list("APIC").first
        assert_equal "image/jpeg", written_apic.mime_type
        assert_equal "desc", written_apic.description
        assert_equal picture_data, written_apic.picture
        written_file.close
      end

      should "be able to set field_list" do
        tit2 = TagLib::ID3v2::TextIdentificationFrame.new("TIT2", TagLib::String::UTF8)
        texts = ["one", "two"]
        tit2.field_list = texts
        assert_equal texts, tit2.field_list
        @tag.add_frame(tit2)
        success = @file.save
        assert success
      end

      should "not fail when field_list is nil" do
        tit2 = TagLib::ID3v2::TextIdentificationFrame.new("TIT2", TagLib::String::UTF8)
        tit2.field_list = nil
        assert_equal [], tit2.field_list
      end

      if HAVE_ENCODING
        should "be able to set unicode fields" do
          # Hello, Unicode Snowman (not in Latin1)
          text = "Hello, \u{2603}"

          # If we don't set the default text encoding to UTF-8, taglib
          # will print a warning
          frame_factory = TagLib::ID3v2::FrameFactory.instance
          frame_factory.default_text_encoding = TagLib::String::UTF8

          @tag.title = text
          @file.save

          assert_equal text, @tag.title
        end
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
