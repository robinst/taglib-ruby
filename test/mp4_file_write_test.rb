require File.join(File.dirname(__FILE__), 'helper')

class MP4FileWriteTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/mp4.m4a"
  OUTPUT_FILE = "test/data/output.m4a"
  PICTURE_FILE = "test/data/globe_east_540.jpg"

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

    should "be able to add and save new cover art" do
      item_list_map = @file.tag.item_list_map
      cover_art_list = item_list_map['covr'].to_cover_art_list
      assert_equal 1, cover_art_list.size

      data = File.open(PICTURE_FILE, 'rb') { |f| f.read }
      new_cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, data)

      cover_art_list << new_cover_art
      item_list_map.insert('covr', TagLib::MP4::Item.from_cover_art_list(cover_art_list))
      assert_equal 2, item_list_map['covr'].to_cover_art_list.size

      success = @file.save
      assert success

      reloaded do |file|
        written_cover_art = file.tag.item_list_map['covr'].to_cover_art_list.last
        assert_equal TagLib::MP4::CoverArt::JPEG, written_cover_art.format
        assert_equal data, written_cover_art.data
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
