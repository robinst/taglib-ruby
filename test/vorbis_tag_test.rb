require File.join(File.dirname(__FILE__), 'helper')
require 'base64'

class TestVorbisTag < Test::Unit::TestCase
  PIC1_FILE = "test/data/globe_east_90.jpg"
  PIC1_DATA = File.open(PIC1_FILE, 'rb') { |f| f.read }
  PIC1_DATA_B64 = Base64.strict_encode64(PIC1_DATA)

  PIC2_FILE = "test/data/globe_east_540.jpg"
  PIC2_DATA = File.open(PIC1_FILE, 'rb') { |f| f.read }
  PIC2_DATA_B64 = Base64.strict_encode64(PIC1_DATA)

  MBP_PIC1 = TagLib::FLAC::Picture.new.tap { |pic|
    pic.type = TagLib::FLAC::Picture::FrontCover
    pic.mime_type = "image/jpeg"
    pic.description = "Globe"
    pic.width = 90
    pic.height = 90
    pic.color_depth = 24
    pic.data = PIC1_DATA
  }

  MBP_PIC2 = TagLib::FLAC::Picture.new.tap { |pic|
    pic.type = TagLib::FLAC::Picture::FrontCover
    pic.mime_type = "image/jpeg"
    pic.description = "Another description"
    pic.width = 90
    pic.height = 90
    pic.data = PIC1_DATA
  }

  MBP_PIC1_B64 = Base64.strict_encode64(MBP_PIC1.render)
  MBP_PIC2_B64 = Base64.strict_encode64(MBP_PIC2.render)

  COVERART_PIC1 = TagLib::FLAC::Picture.new.tap { |pic|
    pic.type = TagLib::FLAC::Picture::Other
    pic.mime_type = "image/"
    pic.data = PIC1_DATA
  }

  COVERART_PIC2 = TagLib::FLAC::Picture.new.tap { |pic|
    pic.type = TagLib::FLAC::Picture::Other
    pic.mime_type = "image/"
    pic.data = PIC2_DATA
  }

  COVERART_PIC1_B64 = Base64.strict_encode64(COVERART_PIC1.render)
  COVERART_PIC2_B64 = Base64.strict_encode64(COVERART_PIC2.render)

  context "The vorbis.oga file tag" do
    setup do
      @file = TagLib::Ogg::Vorbis::File.new("test/data/vorbis.oga")
      @tag = @file.tag
    end

    should "contain basic tag information" do
      assert_equal "Title", @tag.title
      assert_equal "Artist", @tag.artist
      assert_equal "Album", @tag.album
      assert_equal "Test file", @tag.comment
      assert_equal "Pop", @tag.genre
      assert_equal 2011, @tag.year
      assert_equal 7, @tag.track
      assert_equal false, @tag.empty?
    end

    should "have contains? method" do
      assert @tag.contains?('TITLE')
      assert !@tag.contains?('DOESNTEXIST')
    end

    should "have field_count" do
      assert_equal 18, @tag.field_count
    end

    should "have vendor_id" do
      assert_equal "Xiph.Org libVorbis I 20101101 (Schaufenugget)", @tag.vendor_id
    end

    context "fields" do
      setup do
        @fields = @tag.field_list_map
      end

      should "exist" do
        assert_not_nil @fields
      end

      should "be usable as a Hash" do
        assert_equal ["Title"], @fields['TITLE']
        assert_nil @fields['DOESNTEXIST']
      end

      should "be able to return more than one value for a key" do
        assert_equal ["A", "B"], @fields['MULTIPLE']
      end

      should "have METADATA_BLOCK_PICTURE" do
        mbp_field = @fields['METADATA_BLOCK_PICTURE']

        # Starting with Taglib 1.11, COVERART are transformed to METADATA_BLOCK_PICTURE
        if TagLib::TAGLIB_MAJOR_VERSION > 1 || (TagLib::TAGLIB_MAJOR_VERSION == 1 && TagLib::TAGLIB_MINOR_VERSION >= 11)
          assert_equal 2, mbp_field.size
          assert_includes mbp_field, COVERART_PIC1_B64
          assert_includes mbp_field, MBP_PIC1_B64
        else
          assert_equal [MBP_PIC1_B64], mbp_field
        end
      end

      should "have COVERART" do
        # Starting with Taglib 1.11, COVERART are transformed to METADATA_BLOCK_PICTURE
        if TagLib::TAGLIB_MAJOR_VERSION > 1 || (TagLib::TAGLIB_MAJOR_VERSION == 1 && TagLib::TAGLIB_MINOR_VERSION >= 11)
          assert_nil @fields['COVERART']
        else
          assert_equal 1, @fields['COVERART'].size
          assert_equal [PIC1_DATA_B64], @fields['COVERART']
        end
      end
    end

    should "support add_field with replace" do
      @tag.add_field('TITLE', "New Title")
      assert_equal ["New Title"], @tag.field_list_map['TITLE']
    end

    should "support add_field without replace" do
      replace = false
      @tag.add_field('TITLE', "Additional Title", replace)
      assert_equal ["Title", "Additional Title"], @tag.field_list_map['TITLE']
    end

    should "support remove_field with value" do
      @tag.remove_field('MULTIPLE', "A")
      assert_equal ["B"], @tag.field_list_map['MULTIPLE']
    end

    should "support remove_field without value" do
      @tag.remove_field('MULTIPLE')
      assert !@tag.contains?('MULTIPLE')
    end

    # Starting with Taglib 1.11, pictures are not accessible as a standard text field but
    # through a dedicated list. For backward compatibility, Taglib-ruby injects pictures
    # in the METADA_BLOCK_PICTURE field. COVERART pictures are converted to the
    # METADA_BLOCK_PICTURE format. We are here testing the special treatment pictures
    # are getting starting with Taglib 1.11.
    if TagLib::TAGLIB_MAJOR_VERSION > 1 || (TagLib::TAGLIB_MAJOR_VERSION == 1 && TagLib::TAGLIB_MINOR_VERSION >= 11)
      context "METADATA_BLOCK_PICTURE field" do
        should "support being removed" do
          refute_nil @tag.field_list_map['METADATA_BLOCK_PICTURE']

          @tag.remove_field 'METADATA_BLOCK_PICTURE'

          assert_nil @tag.field_list_map['METADATA_BLOCK_PICTURE']
        end

        should "support removing a picture" do
          pic_to_remove = @tag.field_list_map['METADATA_BLOCK_PICTURE'][0]

          # Trying to remove an unknown picture
          @tag.remove_field 'METADATA_BLOCK_PICTURE', Base64.strict_encode64(TagLib::FLAC::Picture.new.render)

          assert_includes @tag.field_list_map['METADATA_BLOCK_PICTURE'], pic_to_remove

          @tag.remove_field 'METADATA_BLOCK_PICTURE', pic_to_remove

          @tag.field_list_map['METADATA_BLOCK_PICTURE'].tap { |mbp_field|
            refute_nil mbp_field
            refute_includes mbp_field, pic_to_remove
          }
        end

        should "support adding a new picture" do
          original_pics = @tag.field_list_map['METADATA_BLOCK_PICTURE']

          refute_includes original_pics, MBP_PIC2_B64

          @tag.add_field('METADATA_BLOCK_PICTURE', MBP_PIC2_B64, false)

          new_pics = @tag.field_list_map['METADATA_BLOCK_PICTURE']

          assert_includes new_pics, MBP_PIC2_B64

          original_pics.each { |pic|
            assert_includes new_pics, pic
          }
        end

        should "support replacing pictures" do
          refute_includes @tag.field_list_map['METADATA_BLOCK_PICTURE'], MBP_PIC2_B64

          @tag.add_field('METADATA_BLOCK_PICTURE', MBP_PIC2_B64)

          assert_equal [MBP_PIC2_B64], @tag.field_list_map['METADATA_BLOCK_PICTURE']
        end
      end

      # These tests highlight the fact that COVERART pictures are automatically
      # converted to METADATA_BLOCK_PICTURE.
      context "COVERART field" do
        should "support adding a new picture" do
          original_pics = @tag.field_list_map['METADATA_BLOCK_PICTURE']

          refute_includes original_pics, PIC2_DATA_B64

          @tag.add_field('COVERART', PIC2_DATA_B64, false)

          new_fields = @tag.field_list_map

          assert_nil new_fields['COVERART']

          new_pics = new_fields['METADATA_BLOCK_PICTURE']

          refute_includes new_pics, PIC2_DATA_B64

          assert_includes new_pics, COVERART_PIC2_B64

          original_pics.each { |pic|
            assert_includes new_pics, pic
          }
        end

        should "support replacing pictures" do
          refute_includes @tag.field_list_map['METADATA_BLOCK_PICTURE'], PIC2_DATA_B64

          @tag.add_field('COVERART', PIC2_DATA_B64)

          new_fields = @tag.field_list_map

          assert_nil new_fields['COVERART']

          new_pictures = new_fields['METADATA_BLOCK_PICTURE']

          refute_includes new_pictures, PIC2_DATA_B64

          assert_equal [COVERART_PIC2_B64], new_pictures
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
