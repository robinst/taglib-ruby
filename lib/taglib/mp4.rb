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
      if !(ary.is_a? Array)
        raise ArgumentError, 'argument should be an array'
      elsif ary.length != 2
        raise ArgumentError, 'argument should have exactly two elements'
      else
        new(*ary)
      end
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
