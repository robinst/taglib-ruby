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

  class Item
    # [8] pry(main)> ls TagLib::MP4::Item
    # TagLib::MP4::Item.methods:
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
    # TagLib::MP4::Item#methods:
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

    # TODO!!
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
  #
  class ItemListMap
    # [9] pry(main)> ls TagLib::MP4::ItemListMap
    # TagLib::MP4::ItemListMap#methods: []  _clear  _insert  clear  contains  empty?  erase  fetch  has_key?  include?  insert  size  to_a
  end
  #
  class Properties < TagLib::AudioProperties
    # [11] pry(main)> ls TagLib::MP4::Properties
    # TagLib::MP4::Properties#methods: bitrate  bits_per_sample  channels  encrypted?  length  sample_rate
  end
  #
end
