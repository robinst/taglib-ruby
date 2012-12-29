require File.join(File.dirname(__FILE__), 'helper')

class MP4ItemsTest < Test::Unit::TestCase
  context "The mp4.m4a file's items" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
      @tag = @file.tag
      @item_list_map = @file.tag.item_list_map
      @item_keys = [
        "\u00A9nam", "\u00A9ART", "\u00A9alb", "\u00A9cmt", "\u00A9gen",
        "\u00A9day", "trkn", "\u00A9too", "\u00A9cpy"
      ]
    end

    context "item_list_map" do
      should "exist" do
        assert_not_nil @item_list_map
      end

      should "not be empty" do
        assert_equal false, @item_list_map.empty?
      end

      should "contain 9 items" do
        assert_equal @item_keys.count, @item_list_map.size
      end

      should "have keys" do
        assert_equal true, @item_list_map.contains("trkn")
        assert_equal true, @item_list_map.has_key?("\u00A9too")
        assert_equal true, @item_list_map.include?("\u00A9cpy")
        assert_equal false, @item_list_map.include?("none such key")
      end

      should "look up keys" do
        assert_nil @item_list_map["none such key"]
        assert_equal ["Title"], @item_list_map["\u00A9nam"].to_string_list
      end

      should "be clearable" do
        assert_equal 9, @item_list_map.size
        comment = @item_list_map["\u00A9cmt"]
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
        assert_equal 9, array.count
        array.each do |object|
          assert_equal Array, object.class
          assert_equal 2, object.count
          assert_equal String, object.first.class
          assert_equal TagLib::MP4::Item, object.last.class
        end
      end
    end

    should "be removable" do
      assert_equal 9, @item_list_map.size
      title = @item_list_map["\u00A9nam"]
      @item_list_map.erase("\u00A9nam")
      assert_equal 8, @item_list_map.size
      begin
        title.to_string_list
        flunk("Should have raised ObjectPreviouslyDeleted.")
      rescue => e
        assert_equal "ObjectPreviouslyDeleted", e.class.to_s
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
