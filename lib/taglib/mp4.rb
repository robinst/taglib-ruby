require 'taglib_mp4'

module TagLib::MP4
  class File
    extend ::TagLib::FileOpenable
  end

  class ItemListMap
    def [](key)
      fetch(key)
    end

    def delete(key)
      if has_key?(key)
        fetch(key).tap do
          erase(key)
        end
      end
    end
  end
end
