# encoding: utf-8
require File.join(File.dirname(__FILE__), 'helper')

class MP4ItemsTest < Test::Unit::TestCase
  ITUNES_LEADER = "\xC2\xA9"

  context "The mp4.m4a file's items" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
      @tag = @file.tag
      @item_list_map = @file.tag.item_list_map
      @item_keys = [
        "cover", "#{ITUNES_LEADER}nam", "#{ITUNES_LEADER}ART", "#{ITUNES_LEADER}alb",
        "#{ITUNES_LEADER}cmt", "#{ITUNES_LEADER}gen", "#{ITUNES_LEADER}day",
        "trkn", "#{ITUNES_LEADER}too", "#{ITUNES_LEADER}cpy"
      ]
    end

    context "item_list_map" do
      should "exist" do
        assert_not_nil @item_list_map
      end

      should "not be empty" do
        assert_equal false, @item_list_map.empty?
      end

      should "contain 10 items" do
        assert_equal @item_keys.count, @item_list_map.size
      end

      should "have keys" do
        assert_equal true, @item_list_map.contains("trkn")
        assert_equal true, @item_list_map.has_key?("#{ITUNES_LEADER}too")
        assert_equal true, @item_list_map.include?("#{ITUNES_LEADER}cpy")
        assert_equal false, @item_list_map.include?("none such key")
      end

      should "look up keys" do
        assert_nil @item_list_map["none such key"]
        assert_equal ["Title"], @item_list_map["#{ITUNES_LEADER}nam"].to_string_list
      end

      should "be clearable" do
        assert_equal 10, @item_list_map.size
        comment = @item_list_map["#{ITUNES_LEADER}cmt"]
        @item_list_map.clear
        assert_equal true, @item_list_map.empty?
        begin
          comment.to_string_list
          flunk("Should have raised ObjectPreviouslyDeleted.")
        rescue => e
          assert_equal "ObjectPreviouslyDeleted", e.class.to_s
        end
      end

      should "be convertable to an array" do
        array = @item_list_map.to_a
        assert_equal 10, array.count
        array.each do |object|
          assert_equal Array, object.class
          assert_equal 2, object.count
          assert_equal String, object.first.class
          assert_equal TagLib::MP4::Item, object.last.class
        end
      end
    end

    should "be removable" do
      assert_equal 10, @item_list_map.size
      title = @item_list_map["#{ITUNES_LEADER}nam"]
      @item_list_map.erase("#{ITUNES_LEADER}nam")
      assert_equal 9, @item_list_map.size
      begin
        title.to_string_list
        flunk("Should have raised ObjectPreviouslyDeleted.")
      rescue => e
        assert_equal "ObjectPreviouslyDeleted", e.class.to_s
      end
    end

    context "inserting items" do
      should "insert a new item" do
        new_title = TagLib::MP4::Item.from_string_list(['new title'])
        @item_list_map.insert("#{ITUNES_LEADER}nam", new_title)
        new_title = nil
        GC.start
        assert_equal ['new title'], @item_list_map["#{ITUNES_LEADER}nam"].to_string_list
      end

      should "unlink items that get replaced" do
        title = @item_list_map["#{ITUNES_LEADER}nam"]
        @item_list_map.insert("#{ITUNES_LEADER}nam", TagLib::MP4::Item.from_int(1))
        begin
          title.to_string_list
          flunk("Should have raised ObjectPreviouslyDeleted.")
        rescue => e
          assert_equal "ObjectPreviouslyDeleted", e.class.to_s
        end
      end
    end

    context "TagLib::MP4::Item" do
      should "be creatable from an int" do
        item = TagLib::MP4::Item.from_int(-42)
        assert_equal TagLib::MP4::Item, item.class
        assert_equal -42, item.to_int
      end

      should "be creatable from a boolean" do
        item = TagLib::MP4::Item.from_bool(false)
        assert_equal TagLib::MP4::Item, item.class
        assert_equal false, item.to_bool
      end

      context ".from_int_pair" do
        should "be creatable from a pair of ints" do
          item = TagLib::MP4::Item.from_int_pair([123, 456])
          assert_equal TagLib::MP4::Item, item.class
          assert_equal [123, 456], item.to_int_pair
        end

        should "raise an error when passed something other than an Array" do
          begin
            TagLib::MP4::Item.from_int_pair(1)
            flunk("Should have raised ArgumentError.")
          rescue => e
            assert_equal "ArgumentError", e.class.to_s
          end
        end

        should "raise an error when passed an Array with more than two elements" do
          begin
            TagLib::MP4::Item.from_int_pair([1, 2, 3])
            flunk("Should have raised ArgumentError.")
          rescue => e
            assert_equal "ArgumentError", e.class.to_s
          end
        end

        should "raise an error when passed an Array with less than two elements" do
          begin
            TagLib::MP4::Item.from_int_pair([1])
            flunk("Should have raised ArgumentError.")
          rescue => e
            assert_equal "ArgumentError", e.class.to_s
          end
        end
      end

      context "created from an array of strings" do
        should "interpreted as strings with an encoding" do
          item = TagLib::MP4::Item.from_string_list(["héllo"])
          assert_equal TagLib::MP4::Item, item.class
          assert_equal ["héllo"], item.to_string_list
        end
      end

      should "be creatable from a CoverArt list" do
        cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, 'foo')
        item = TagLib::MP4::Item.from_cover_art_list([cover_art])
        assert_equal TagLib::MP4::Item, item.class
        new_cover_art = item.to_cover_art_list.first
        assert_equal 'foo', new_cover_art.data
        assert_equal TagLib::MP4::CoverArt::JPEG, new_cover_art.format
      end
    end

    context "TagLib::MP4::CoverArt" do
      should "be creatable from a string" do
        cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, 'foo')
        assert_equal TagLib::MP4::CoverArt::JPEG, cover_art.format
        assert_equal 'foo', cover_art.data
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
