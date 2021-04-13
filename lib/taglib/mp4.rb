# frozen-string-literal: true

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
      raise ArgumentError, 'argument should be an array' unless ary.is_a? Array
      raise ArgumentError, 'argument should have exactly two elements' if ary.length != 2

      new(*ary)
    end
  end

  class ItemMap
    alias clear _clear
    alias insert _insert
    alias [] fetch
    alias []= insert
    remove_method :_clear
    remove_method :_insert
  end
end
