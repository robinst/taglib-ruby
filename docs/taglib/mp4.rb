# [1] pry(main)> ls TagLib::MP4
# constants: Atom  AtomData  Atoms  ByteVectorList  File  IntPair  IOStream  Item  ItemListMap  Properties  Tag  TypeBMP  TypeDateTime  TypeDuration  TypeGenred  TypeGIF  TypeHTML  TypeImplicit  TypeInteger  TypeISRC  TypeJPEG  TypeMI3P  TypePNG  TypeRIAAPA  TypeSJIS  TypeUndefined  TypeUPC  TypeURL  TypeUTF16  TypeUTF8  TypeUUID  TypeXML
#

module TagLib::MP4

  # The file class for '.m4a' files.
  #
  # @example Finding an MP4 item by field name
  #   TagLib::MP4::File.open("file.m4a") do |file|
  #     item_list_map = file.tag.item_list_map
  #     title = item_list_map["\u00a9nam"].to_string_list
  #     puts title.first
  #   end
  class File < TagLib::File

    # {include:TagLib::FileRef.open}
    #
    # @param (see #initialize)
    # @yield [file] the {File} object, as obtained by {#initialize}
    # @return the return value of the block
    #
    def self.open(filename, read_properties=true)
    end

    # Load an M4A file.
    #
    # @param [String] filename
    # @param [Boolean] read_properties if audio properties should be
    #                  read
    # @return [TagLib::MP4::File]
    def initialize(filename, read_properties=true)
    end

    # Returns the MP4 tag in the file
    #
    # @return [TagLib::MP4::Tag]
    # @return [nil] if not present
    def tag
    end

    def audio_properties
    end

    def close
    end

    def  save
    end

  end

  class Tag < TagLib::Tag
    # Returns the map containing all the items in the tag
    # @return [TagLib::MP4::ItemListMap]
    def item_list_map
    end
  end

  # TagLib's `MP4::Item` class is a C++ union. To create a new Item with a value
  # of the right type, use one of the `Item.from_<type>`-constructors. The use
  # of `Item.new` is discouraged. For more information, see [the TagLib
  # documentation of `Item`](http://taglib.github.com/api/classTagLib_1_1MP4_1_1Item.html).
  # @example Using a specific constructor
  #   > item = TagLib::MP4::Item.from_string_list(['hello'])
  #   => #<TagLib::MP4::Item:0x007ffd59796d60 @__swigtype__="_p_TagLib__MP4__Item">
  #   > item.to_string_list
  #   => ["hello"]
  #   > item.to_int # Good luck!
  #   => 1538916358
  #
  class Item
    # @return [TagLib::MP4::Item]
    def self.from_bool
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_byte
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_int
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_long_long
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_string_list
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_byte_vector_list
    end
    #
    # @return [TagLib::MP4::Item]
    def self.from_uint
    end

    attr_accessor :atom_data_type

    # @return [Boolean]
    def
      to_bool
    end

    # @return [Fixnum]
    def to_byte
    end

    # @return [Array<String>]
    def to_byte_vector_list
    end

    # @return [Array<TagLib::MP4::CoverArt>]
    def to_cover_art_list
    end

    # @return [Fixnum]
    def to_int
    end

    # @return [Array<Fixnum, Fixnum>]
    def to_int_pair
    end

    # @return [Fixnum]
    def to_long_long
    end

    # @return [Array<String>]
    def to_string_list
    end

    # @return [Fixnum]
    def to_uint
    end

    # @return [Boolean]
    def valid?
    end
  end

  # The underlying C++-structure of `ItemListMap` inherits from `std::map`.
  # Consequently, `ItemListMap` behaves differently from a Ruby hash in a few
  # places. Be sure to read the documentation of the instance methods below.
  class ItemListMap
    # Return the Item under `key`, or `nil` if no Item is present.
    # @param [String] key
    # @return [TagLib::MP4::Item]
    # @return [nil] if not present
    def fetch(key)
    end
    alias :[] :fetch

    # @example Warning: things get destroyed
    #   > mp4.tag.item_list_map["\u00a9nam"]
    #   => #<TagLib::MP4::Item:0x007f9199f9f2b8 @__swigtype__="_p_TagLib__MP4__Item">
    #   > remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   => #<TagLib::MP4::Item:0x007f9199f9f2b8 @__swigtype__="_p_TagLib__MP4__Item">
    #   > mp4.tag.item_list_map.clear
    #   => nil
    #   > remember_me.to_string_list
    #   ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f9199...
    #   	in SWIG method 'toStringList'
    #   from (pry):7:in `to_string_list'
    #
    # Remove all Items from self, destroying each Item.
    # @return [nil]
    def clear
    end

    # Returns true if self has an Item under `key`.
    # @param [String] key
    # @return [Boolean]
    def contains(key)
    end
    alias :has_key? :contains
    alias :include? :contains

    # Returns true if self is empty
    # @return [Boolean]
    def empty?
    end

    # Remove and destroy the value under `key`, if present.
    # @example Warning: things get destroyed
    #   > remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   => #<TagLib::MP4::Item:0x007f919a99bac8 @__swigtype__="_p_TagLib__MP4__Item">
    #   > mp4.tag.item_list_map.erase("\u00a9nam")
    #   => nil
    #   > remember_me.to_string_list
    #   ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f919a...
    #   	in SWIG method 'toStringList'
    #   from (pry):13:in `to_string_list'
    #
    # @param [String] key
    # @return [nil]
    def erase(key)
    end

    # Insert an item at `key`, destoying the existing item under `key`.
    # @example Warning: things get destroyed
    #   > remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   => #<TagLib::MP4::Item:0x007f919aa062b0 @__swigtype__="_p_TagLib__MP4__Item">
    #   > mp4.tag.item_list_map.insert("\u00a9nam", TagLib::MP4::Item.from_string_list(['New']))
    #   => nil
    #   > remember_me.to_string_list
    #   ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f919a...
    #   	in SWIG method 'toStringList'
    #   from (pry):18:in `to_string_list'
    # @param [String] key
    # @param [TagLib::MP4::Item] item
    # @return [nil]
    def insert(key, item)
    end

    # The number of Items in self.
    # @return [FixNum]
    def size
    end

    # Convert self into an array of `[key, value]` pairs.
    # @return [Array<Array<String, TagLib::MP4::Item>>]
    def to_a
    end
  end
  #
  class Properties < TagLib::AudioProperties
    attr_reader :bits_per_sample, :encrypted?
  end
  #
end
