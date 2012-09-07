require File.join(File.dirname(__FILE__), 'helper')

class MP4FileWriteTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/mp4.m4a"
  OUTPUT_FILE = "test/data/output.m4a"

  def reloaded
    TagLib::MP4::File.open(OUTPUT_FILE, false) do |file|
      yield file
    end
  end

  context "TagLib::MP4::File" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::MP4::File.new(OUTPUT_FILE, false)
    end

    should "be able to save the title" do
      tag = @file.tag
      assert_not_nil tag
      tag.title = "New Title"
      success = @file.save
      assert success
      @file.close
      @file = nil

      written_title = reloaded do |file|
        file.tag.title
      end
      assert_equal "New Title", written_title
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
