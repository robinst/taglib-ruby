# ## String Encodings
#
# Sometimes, it is necessary to specify which encoding should be used to
# store strings in tags. For this, the following constants are defined:
#
# * `TagLib::String::Latin1`
# * `TagLib::String::UTF16`
# * `TagLib::String::UTF16BE`
# * `TagLib::String::UTF8`
# * `TagLib::String::UTF16LE`
module TagLib

  # @abstract Base class for files, see subclasses.
  class File
  end

  # @abstract Base class for tags.
  #
  # This is a unified view which provides basic tag information, which
  # is common in all tag formats. See subclasses for functionality that
  # goes beyond this interface.
  class Tag
    # @return [String] the album
    # @return [nil] if not present
    attr_accessor :album

    # @return [String] the artist/interpret
    # @return [nil] if not present
    attr_accessor :artist

    # @return [String] the comment
    # @return [nil] if not present
    attr_accessor :comment

    # @return [String] the genre
    # @return [nil] if not present
    attr_accessor :genre

    # @return [String] the title
    # @return [nil] if not present
    attr_accessor :title

    # @return [Integer] the track number
    # @return [0] if not present
    attr_accessor :track

    # @return [Integer] the year
    # @return [0] if not present
    attr_accessor :year

    # @return [Boolean]
    def empty?; end
  end

  # @abstract Base class for audio properties.
  class AudioProperties
    # @return [Integer] length of the file in seconds
    def length
    end

    # @return [Integer] bit rate in kb/s (kilobit per second)
    def bitrate
    end

    # @return [Integer] sample rate in Hz
    def sample_rate
    end

    # @return [Integer] number of channels
    def channels
    end
  end
end
