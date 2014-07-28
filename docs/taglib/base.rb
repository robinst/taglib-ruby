# This is the top-level module of taglib-ruby.
#
# Where to find what:
#
# * Reading/writing basic tag and audio properties without having to
#   know the tagging format: {TagLib::FileRef}
# * Reading properties of MPEG files: {TagLib::MPEG::File}
# * Reading/writing ID3v2 tags: {TagLib::MPEG::File}, {TagLib::RIFF::AIFF::File} and
#   {TagLib::ID3v2::Tag}
# * Reading/writing Ogg Vorbis tags: {TagLib::Ogg::Vorbis::File}
# * Reading/writing FLAC tags: {TagLib::FLAC::File}
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
#
# ## Modifying attributes
#
# Mutable Ruby types (String, Array) returned by TagLib cannot be modified in-place.
#
# @example Modifying an attribute in-place does not work
#   tag.title = 'Title'
#   tag.title
#   # => "Title"
#   tag.title << ' of the song'
#   # => "Title of the song"
#   tag.title
#   # => "Title"
#
# @example You need to replace the existing attribute value
#   tag.title = 'Title'
#   tag.title
#   # => "Title"
#   tag.title = 'Title of the song'
#   tag.title
#   # => "Title of the song"
module TagLib

  # Major version of TagLib the extensions were compiled against
  # (major.minor.patch). Note that the value is not actually 0, but
  # depends on the version of the installed library.
  TAGLIB_MAJOR_VERSION = 0

  # Minor version of TagLib the extensions were compiled against
  # (major.minor.patch). Note that the value is not actually 0, but
  # depends on the version of the installed library.
  TAGLIB_MINOR_VERSION = 0

  # Patch version of TagLib the extensions were compiled against
  # (major.minor.patch). Note that the value is not actually 0, but
  # depends on the version of the installed library.
  TAGLIB_PATCH_VERSION = 0

  # This class allows to read basic tagging and audio properties from
  # files, without having to know what the file type is. Thus, it works
  # for all tagging formats that taglib supports, but only provides a
  # minimal API.
  #
  # Should you need more, use the file type specific classes, see
  # subclasses of {TagLib::File}.
  #
  # @example Reading tags
  #   TagLib::FileRef.open("foo.flac") do |file|
  #     unless file.null?
  #       tag = file.tag
  #       puts tag.artist
  #       puts tag.title
  #     end
  #   end
  #
  # @example Reading audio properties
  #   TagLib::FileRef.open("bar.oga") do |file|
  #     unless file.null?
  #       prop = file.audio_properties
  #       puts prop.length
  #       puts prop.bitrate
  #     end
  #   end
  #
  class FileRef

    # Creates a new file and passes it to the provided block,
    # closing the file automatically at the end of the block.
    #
    # Note that after the block is done, the file is closed and
    # all memory is released for objects read from the file
    # (basically everything from the `TagLib` namespace).
    #
    # Using `open` is preferable to using `new` and then
    # manually `close`.
    #
    # @example Reading a title
    #   title = TagLib::FileRef.open("file.oga") do |file|
    #     tag = file.tag
    #     tag.title
    #   end
    #
    # @param (see #initialize)
    # @yield [file] the {FileRef} object, as obtained by {#initialize}
    # @return the return value of the block
    #
    # @since 0.4.0
    def self.open(filename, read_audio_properties=true,
                   audio_properties_style=TagLib::AudioProperties::Average)
    end

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

    # Gets the audio properties. Before accessing it, check if there
    # were problems reading the file using {#null?}. If the audio
    # properties are accessed anyway, a warning will be printed and it
    # will return nil.
    #
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

    # Gets the tag. Before accessing it, check if there were problems
    # reading the file using {#null?}. If the tag is accessed anyway, a
    # warning will be printed and it will return nil.
    #
    # @return [TagLib::Tag] the tag, or nil
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

    # Save the file and the associated tags.
    #
    # See subclasses, as some provide more control over what is saved.
    #
    # @return [Boolean] whether saving was successful
    def save
    end

    # Closes the file and releases all objects that were read from the
    # file (basically everything from the TagLib namespace).
    #
    # After this method has been called, no other methods on this object
    # may be called. So it's a good idea to always use it like this:
    #
    #     file = TagLib::MPEG::File.new("file.mp3")
    #     # ...
    #     file.close
    #     file = nil
    #
    # This method should always be called as soon as you're finished
    # with a file. Otherwise the file will only be closed when GC is
    # run, which may be much later. On Windows, this is especially
    # important as the file is locked until it is closed.
    #
    # As a better alternative to this, use the `open` class method:
    #
    #     TagLib::MPEG::File.open("file.mp3") do |file|
    #        # ...
    #     end
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
