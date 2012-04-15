require File.join(File.dirname(__FILE__), 'helper')

class FlacFileWriteTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/flac.flac"
  OUTPUT_FILE = "test/data/output.flac"
  PICTURE_FILE = "test/data/globe_east_90.jpg"

  def reloaded
    TagLib::FLAC::File.open(OUTPUT_FILE, false) do |file|
      yield file
    end
  end

  context "TagLib::FLAC::File" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::FLAC::File.new(OUTPUT_FILE, false)
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

    should "be able to remove pictures" do
      assert_equal 1, @file.picture_list.size
      @file.remove_pictures
      assert_equal 0, @file.picture_list.size
      success = @file.save
      assert success
    end

    should "be able to add and save a new picture" do
      picture_data = File.open(PICTURE_FILE, 'rb') { |f| f.read }

      pic = TagLib::FLAC::Picture.new
      pic.type = TagLib::FLAC::Picture::FrontCover
      pic.mime_type = "image/jpeg"
      pic.description = "desc"
      pic.width = 90
      pic.height = 90
      pic.data = picture_data

      assert_equal 1, @file.picture_list.size
      @file.add_picture(pic)
      assert_equal 2, @file.picture_list.size

      success = @file.save
      assert success

      reloaded do |file|
        written_pic = file.picture_list.last
        assert_equal TagLib::FLAC::Picture::FrontCover, written_pic.type
        assert_equal "image/jpeg", written_pic.mime_type
        assert_equal "desc", written_pic.description
        assert_equal 90, written_pic.width
        assert_equal 90, written_pic.height
        assert_equal picture_data, written_pic.data
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
