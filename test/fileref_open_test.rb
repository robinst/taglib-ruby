require File.join(File.dirname(__FILE__), 'helper')

class FileRefOpenTest < Test::Unit::TestCase
  context "TagLib::FileRef.open" do
    should "return result" do
      title = TagLib::FileRef.open("test/data/vorbis.oga", false) do |file|
        tag = file.tag
        assert_not_nil tag
        tag.title
      end
      assert_equal "Title", title
    end

    should "close even with exception" do
      f = nil
      begin
        TagLib::FileRef.open("test/data/vorbis.oga", false) do |file|
          f = file
          raise NotImplementedError
        end
        flunk("Should have raised NotImplementedError.")
      rescue NotImplementedError
        begin
          f.tag
          flunk("Should have raised ObjectPreviouslyDeleted.")
        rescue => e
          assert_equal "ObjectPreviouslyDeleted", e.class.to_s
        end
      end
    end
  end
end
