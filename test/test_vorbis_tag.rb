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
      assert_equal 16, @tag.field_count
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

    should "support remove_field with value" do
      @tag.remove_field('MULTIPLE', "A")
      assert_equal ["B"], @tag.field_list_map['MULTIPLE']
    end

    should "support remove_field without value" do
      @tag.remove_field('MULTIPLE')
      assert !@tag.contains?('MULTIPLE')
    end

    teardown do
      @file.close
      @file = nil
    end
  end
end
