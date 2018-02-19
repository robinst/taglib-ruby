require File.join(File.dirname(__FILE__), 'helper')
require 'base64'

class VorbisFileWriteTest < Test::Unit::TestCase

  SAMPLE_FILE = "test/data/vorbis.oga"
  OUTPUT_FILE = "test/data/output.oga"
  PICTURE_FILE = "test/data/globe_east_90.jpg"

  PICTURE_DATA = File.open(PICTURE_FILE, 'rb') { |f| f.read }
  PICTURE_DATA_B64 = Base64.strict_encode64(PICTURE_DATA)

  def reloaded
    TagLib::Ogg::Vorbis::File.open(OUTPUT_FILE, false) do |file|
      yield file
    end
  end

  context "TagLib::Ogg::Vorbis::File" do
    setup do
      FileUtils.cp SAMPLE_FILE, OUTPUT_FILE
      @file = TagLib::Ogg::Vorbis::File.new(OUTPUT_FILE, false)
    end

    should "be able to save the title" do
      tag = @file.tag
      refute_nil tag
      tag.title = "New Title"

      assert @file.save

      reloaded do |file|
        assert_equal "New Title", file.tag.title
      end
    end

    should "be able to add and save a new METADATA_BLOCK_PICTURE" do
      pic = TagLib::FLAC::Picture.new
      pic.type = TagLib::FLAC::Picture::FrontCover
      pic.mime_type = "image/jpeg"
      pic.description = "something"
      pic.width = 90
      pic.height = 90
      pic.color_depth = 24
      pic.data = PICTURE_DATA

      @file.tag.add_field('METADATA_BLOCK_PICTURE', Base64.strict_encode64(pic.render))

      assert @file.save

      reloaded do |file|
        pictures = file.tag.field_list_map['METADATA_BLOCK_PICTURE']

        assert_equal 1, pictures.size

        written_pic = TagLib::FLAC::Picture.new(Base64.strict_decode64(pictures[0]))
        assert_equal TagLib::FLAC::Picture::FrontCover, written_pic.type
        assert_equal "image/jpeg", written_pic.mime_type
        assert_equal "something", written_pic.description
        assert_equal 90, written_pic.width
        assert_equal 90, written_pic.height
        assert_equal 24, written_pic.color_depth
        assert_equal PICTURE_DATA, written_pic.data
      end
    end

    # This test highlight the fact that starting with Taglib 1.11, a COVERART
    # field will be reloaded as a METADATA_BLOCK_PICTURE.
    if TagLib::TAGLIB_MAJOR_VERSION > 1 || (TagLib::TAGLIB_MAJOR_VERSION == 1 && TagLib::TAGLIB_MINOR_VERSION >= 11)
      should "be able to add and save a new COVERART" do
        @file.tag.add_field('COVERART', PICTURE_DATA_B64)

        assert @file.save

        reloaded do |file|
          fields = file.tag.field_list_map

          assert_nil fields['COVERART']
          assert_equal 1, fields['METADATA_BLOCK_PICTURE'].size

          written_pic = TagLib::FLAC::Picture.new(Base64.strict_decode64(fields['METADATA_BLOCK_PICTURE'][0]))
          assert_equal TagLib::FLAC::Picture::Other, written_pic.type
          assert_equal "image/", written_pic.mime_type
          assert_equal "", written_pic.description
          assert_equal 0, written_pic.width
          assert_equal 0, written_pic.height
          assert_equal 0, written_pic.color_depth
          assert_equal PICTURE_DATA, written_pic.data
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
