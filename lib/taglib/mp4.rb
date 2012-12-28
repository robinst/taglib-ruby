require 'taglib_mp4'

module TagLib::MP4
  class File
    extend ::TagLib::FileOpenable
  end

  class ItemListMap
    def [](key)
      fetch(key)
    end
  end
end
