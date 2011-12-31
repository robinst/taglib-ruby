# This is the top-level module of taglib-ruby.
#
# Where to find what:
#
# * Reading/writing basic tag and audio properties without having to
#   know the tagging format: {TagLib::FileRef}
# * Reading properties of MPEG files: {TagLib::MPEG::File}
# * Reading/writing ID3v2 tags: {TagLib::MPEG::File} and
#   {TagLib::MPEG::File#id3v2_tag}
# * Reading/writing Ogg Vorbis tags: {TagLib::Ogg::Vorbis::File}.
# 
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
#
# For ID3v2 frames, you can also set a default text encoding globally
# using the {TagLib::ID3v2::FrameFactory}.
module TagLib

  # This class allows to read basic tagging and audio properties from
  # files, without having to know what the file type is. Thus, it works
  # for all tagging formats that taglib supports, but only provides a
  # minimal API.
  #
  # Should you need more, use the file type specific classes, see
  # subclasses of {TagLib::File}.
  class FileRef
    # Create a FileRef from a file name.
    #
    # @param [String] filename
    # @param [Boolean] read_audio_properties
    #   true if audio properties should be read
    # @param [TagLib::AudioProperties constants] audio_properties_style
    #   how accurately the audio properties should be read, e.g.
    #   {TagLib::AudioProperties::Average}
    def initialize(filename, read_audio_properties=true,
                   audio_properties_style=TagLib::AudioProperties::Average)
    end

    # @return [TagLib::AudioProperties] the audio properties
    def audio_properties
    end

    # @return [Boolean] if the file is null (i.e. it could not be read)
    def null?
    end

    # Saves the file
    #
    # @return [Boolean] whether saving was successful
    def save
    end

    # @return [TagLib::Tag] the tag
    def tag
    end

    # Closes the file and releases all objects that were read from the
    # file.
    #
    # @see TagLib::File#close
    #
    # @return [void]
    def close
    end
  end

  # @abstract Base class for files, see subclasses.
  class File
    # Closes the file and releases all objects that were read from the
    # file.
    #
    # After this method has been called, no other methods on this object
    # may be called. So it's a good idea to always use it like this:
    #
    #     file.close
    #     file = nil
    #
    # This method should always be called as soon as you're finished
    # with a file. Otherwise the file will only be closed when GC is
    # run, which may be much later. On Windows, this is especially
    # important as the file is locked until it is closed.
    #
    # @return [void]
    def close
    end
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

    Fast = 0
    Average = 1
    Accurate = 2

    # @return [Integer] length of the file in seconds
    attr_reader :length

    # @return [Integer] bit rate in kb/s (kilobit per second)
    attr_reader :bitrate

    # @return [Integer] sample rate in Hz
    attr_reader :sample_rate

    # @return [Integer] number of channels
    attr_reader :channels
  end
end
