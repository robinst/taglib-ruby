require 'taglib_mp4'

module TagLib::MP4
  remove_const :Atom
  remove_const :AtomData
  remove_const :Atoms
  remove_const :IOStream

  class File
    extend ::TagLib::FileOpenable
  end

  class Tag
    remove_method :save
  end

  class ItemListMap
    alias :clear :_clear
    alias :insert :_insert
    remove_method :_clear
    remove_method :_insert

    def [](key)
      fetch(key)
    end
  end
end
