require 'taglib_mp4'

module TagLib::MP4
  class File
    extend ::TagLib::FileOpenable
  end

  class ItemListMap
    alias :clear :_clear
    alias :insert :_insert

    def [](key)
      fetch(key)
    end
  end
end
