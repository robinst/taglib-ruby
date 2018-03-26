require File.join(File.dirname(__FILE__), 'helper')

class TestVorbisTag < Test::Unit::TestCase
  context "The vorbis.oga file tag" do
    setup do
      @file = TagLib::Ogg::Vorbis::File.new("test/data/vorbis.oga")
      @tag = @file.tag
    end

    should "contain basic tag information" do
      assert_equal "Title", @tag.title
      assert_equal "Artist", @tag.artist
      assert_equal "Album", @tag.album
      # Use DESCRIPTION if it exists, otherwise COMMENT.
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

    should "support remove_fields" do
      assert @tag.contains?('MULTIPLE')
      @tag.remove_fields('MULTIPLE')
      refute @tag.contains?('MULTIPLE')
    end

    should "support remove_all_fields" do
      refute_equal 0, @tag.field_count
      @tag.remove_all_fields()
      # remove_all_fields() do not remove pictures
      assert_equal 1, @tag.field_count
    end

    should "have pictures" do
      refute_empty @tag.picture_list
    end

    context "first picture" do
      setup do
        @picture = @tag.picture_list.first
      end

      should "be a TagLib::FLAC::Picture," do
        assert_equal TagLib::FLAC::Picture, @picture.class
      end

      should "have meta-data" do
        assert_equal TagLib::FLAC::Picture::FrontCover, @picture.type
        assert_equal "image/jpeg", @picture.mime_type
        assert_equal "Globe", @picture.description
        assert_equal 90, @picture.width
        assert_equal 90, @picture.height
        assert_equal 24, @picture.color_depth
        assert_equal 0, @picture.num_colors
      end

      should "have data" do
        picture_data = File.open("test/data/globe_east_90.jpg", 'rb'){ |f| f.read }
        assert_equal picture_data, @picture.data
      end
    end

    should "support removing a picture" do
      refute_empty @tag.picture_list
      @tag.remove_picture(@tag.picture_list.first)
      assert_empty @tag.picture_list
    end

    should "support removing all pictures" do
      refute_empty @tag.picture_list
      @tag.remove_all_pictures()
      assert_empty @tag.picture_list
    end

    teardown do
      @file.close
      @file = nil
    end
  end

  context "The XiphComment class" do
    should "support check_key" do
      refute TagLib::Ogg::XiphComment::check_key("")
      refute TagLib::Ogg::XiphComment::check_key("something=")
      refute TagLib::Ogg::XiphComment::check_key("something~")
      assert TagLib::Ogg::XiphComment::check_key("something")
    end
  end
end
