require 'taglib_mp4'

module TagLib::MP4

  class File
    extend ::TagLib::FileOpenable
  end

  class Tag
    remove_method :save
  end

  class Item
    def self.from_int_pair(ary)
      new(*ary)
    end
  end

  class ItemListMap
    alias :clear :_clear
    alias :insert :_insert
    alias :[] :fetch
    remove_method :_clear
    remove_method :_insert

  end
end
