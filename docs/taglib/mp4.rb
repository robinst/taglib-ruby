module TagLib::MP4

  # The file class for '.m4a' files.
  #
  # @example Finding an MP4 item by field name
  #   TagLib::MP4::File.open("file.m4a") do |mp4|
  #     item_list_map = mp4.tag.item_list_map
  #     title = item_list_map["\u00a9nam"].to_string_list
  #     puts title.first
  #   end
  #
  # @example Add new cover art to a tag
  #   image_data = File.open('cover_art.jpeg', 'rb') { |f| f.read }
  #   cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, image_data)
  #   item = TagLib::MP4::Item.from_cover_art_list([cover_art])
  #   mp4.tag.item_list_map.insert('covr', item)
  #   # => nil
  #   mp4.save
  #   # => true
  #
  # @example Extract cover art from a tag and save it to disk
  #   cover_art_list = mp4.tag.item_list_map['covr'].to_cover_art_list
  #   cover_art = cover_art_list.first
  #   cover_art.format
  #   # => 13
  #   cover_art.format == TagLib::MP4::CoverArt::JPEG
  #   # => true
  #   File.open('cover_art.jpeg', 'wb') do |file|
  #     file.write(cover_art.data)
  #   end
  #   # => 3108
  #
  # @example List all keys and items in the tag
  #   mp4.tag.item_list_map.to_a
  #   # => [["covr",
  #   #   #<TagLib::MP4::Item:0x007f9bab61e3d0 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["trkn",
  #   #   #<TagLib::MP4::Item:0x007f9bab61e268 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©ART",
  #   #   #<TagLib::MP4::Item:0x007f9bab61e128 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©alb",
  #   #   #<TagLib::MP4::Item:0x007f9bab61df48 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©cmt",
  #   #   #<TagLib::MP4::Item:0x007f9bab61de08 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©cpy",
  #   #   #<TagLib::MP4::Item:0x007f9bab61dc78 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©day",
  #   #   #<TagLib::MP4::Item:0x007f9bab61db88 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©gen",
  #   #   #<TagLib::MP4::Item:0x007f9bab61da48 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©nam",
  #   #   #<TagLib::MP4::Item:0x007f9bab61d930 @__swigtype__="_p_TagLib__MP4__Item">],
  #   #  ["©too",
  #   #   #<TagLib::MP4::Item:0x007f9bab61d818 @__swigtype__="_p_TagLib__MP4__Item">]]
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

    # @return [TagLib::MP4::Properties]
    def audio_properties
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
  #   item = TagLib::MP4::Item.from_string_list(['hello'])
  #   # => #<TagLib::MP4::Item:0x007ffd59796d60 @__swigtype__="_p_TagLib__MP4__Item">
  #   item.to_string_list
  #   # => ["hello"]
  #   item.to_int # Good luck!
  #   # => 1538916358
  #
  class Item
    # @param [Boolean] value
    # @return [TagLib::MP4::Item]
    def self.from_bool(value)
    end

    # @param [Fixnum] number
    # @return [TagLib::MP4::Item]
    def self.from_int(number)
    end

    # @example
    #   TagLib::MP4::Item.from_int_pair([4, 11])
    # @param [Array<Fixnum, Fixnum>] integer_pair
    # @return [TagLib::MP4::Item]
    def self.from_int_pair(integer_pair)
    end

    # @param [Array<String>] string_array
    # @return [TagLib::MP4::Item]
    def self.from_string_list(string_array)
    end

    # @return [Boolean]
    def to_bool
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

    # @return [Array<String>]
    def to_string_list
    end

    # @return [Boolean]
    def valid?
    end
  end

  # The underlying C++-structure of `ItemListMap` inherits from `std::map`.
  # Consequently, `ItemListMap` behaves differently from a Ruby hash in a few
  # places: the C++ memory management strategies of ItemListMap can lead to
  # a situation where a Ruby object refers to a location in memory that was
  # freed by C++. To prevent Ruby from crashing on us with a segmentation
  # fault, we raise an `ObjectPreviouslyDeleted` exception when we try to access
  # data that is no longer available.
  class ItemListMap
    # Return the Item under `key`, or `nil` if no Item is present.
    # @param [String] key
    # @return [TagLib::MP4::Item]
    # @return [nil] if not present
    def fetch(key)
    end
    alias :[] :fetch

    # @example Triggering an ObjectPreviouslyDeleted exception
    #   remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   mp4.tag.item_list_map.clear
    #   # => nil
    #   remember_me.to_string_list
    #   # ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f9199...
    #   # 	in SWIG method 'toStringList'
    #   # from (pry):7:in `to_string_list'
    #
    # Remove all Items from self, destroying each Item.
    # @note May free memory referred to by Ruby objects
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
    # @example Triggering an ObjectPreviouslyDeleted exception
    #   remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   mp4.tag.item_list_map.erase("\u00a9nam")
    #   # => nil
    #   remember_me.to_string_list
    #   # ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f919a...
    #   # 	in SWIG method 'toStringList'
    #   # from (pry):13:in `to_string_list'
    #
    # @note May free memory referred to by Ruby objects
    # @param [String] key
    # @return [nil]
    def erase(key)
    end

    # Insert an item at `key`, destoying the existing item under `key`.
    # @example Triggering an ObjectPreviouslyDeleted exception
    #   remember_me = mp4.tag.item_list_map["\u00a9nam"]
    #   mp4.tag.item_list_map.insert("\u00a9nam", TagLib::MP4::Item.from_string_list(['New']))
    #   remember_me.to_string_list
    #   # ObjectPreviouslyDeleted: Expected argument 0 of type TagLib::MP4::Item const *, but got TagLib::MP4::Item #<TagLib::MP4::Item:0x007f919a...
    #   # 	in SWIG method 'toStringList'
    #   # from (pry):18:in `to_string_list'
    # @note May free memory referred to by Ruby objects
    # @param [String] key
    # @param [TagLib::MP4::Item] item
    # @return [nil]
    def insert(key, item)
    end

    # The number of Items in self.
    # @return [Fixnum]
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

  # The `CoverArt` class is used to embed cover art images in MP4 tags.
  #
  # @example Creating a new CoverArt instance
  #   image_data = File.open('cover_art.jpeg', 'rb') { |f| f.read }
  #   cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, image_data)
  class CoverArt
    JPEG = 0x0D
    PNG  = 0x0E

    # Returns the format of the image data: `JPEG` or `PNG`.
    # @return [Fixnum]
    attr_reader :format

    # Returns the raw image data
    # @return [String]
   attr_reader :data

    # @param [Fixnum] format
    # @param [String] data
    # @return [TagLib::MP4::CoverArt]
    def initialize(format, data)
    end
  end
end
