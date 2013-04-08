require File.join(File.dirname(__FILE__), 'helper')

require 'fileutils'

class TestFileRefWrite < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/sample.mp3"
  OUTPUT_FILE = "test/data/output.mp3"

  context "TagLib::FileRef" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::MPEG::File.new(OUTPUT_FILE, false)
    end

    should "be able to save the title" do
      tag = @file.tag
      assert_not_nil tag
      tag.title = "New Title"
      success = @file.save
      assert success
      @file.close
      @file = nil

      written_file = TagLib::MPEG::File.new(OUTPUT_FILE, false)
      assert_equal "New Title", written_file.tag.title
      written_file.close
    end

    should "not segfault when setting int" do
      begin
        @file.tag.title = 42
        flunk("Should have raised a TypeError")
      rescue TypeError
        # this is good
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

  context "TagLib::FileRef.open" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
    end

    should "be able to save file" do
      TagLib::MPEG::File.open(OUTPUT_FILE, false) do |file|
        tag = file.tag
        tag.title = "New Title"
        file.save
      end

      title = TagLib::MPEG::File.open(OUTPUT_FILE, false) do |file|
        tag = file.tag
        tag.title
      end
      assert_equal "New Title", title
    end

    teardown do
      FileUtils.rm OUTPUT_FILE
    end
  end
end
