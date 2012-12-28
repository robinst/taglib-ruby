require File.join(File.dirname(__FILE__), 'helper')

class MP4ItemsTest < Test::Unit::TestCase
  context "TagLib::MP4::Tag" do
    setup do
      @file = TagLib::MP4::File.new("test/data/mp4.m4a")
      @tag = @file.tag
      @item_list_map = @file.tag.item_list_map
    end

    context "item_list_map" do
      setup do
        @item_keys = [
          "\u00A9nam", "\u00A9ART", "\u00A9alb", "\u00A9cmt", "\u00A9gen",
          "\u00A9day", "trkn", "\u00A9too", "\u00A9cpy"
        ]
      end

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
        assert_equal "Title", @item_list_map["\u00A9nam"]
      end

      context "delete keys" do
        should "delete the key" do
          assert_equal 7, @item_list_map.delete("trkn")
          assert_equal false, @item_list_map.has_key?("trkn")
        end

        should "return nil when key does not exist" do
          assert_nil @item_list_map.delete("none such key")
        end
      end
    end

    teardown do
      @file.close
      @file = nil
    end
  end

end
