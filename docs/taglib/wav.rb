# @since 0.7.0
module TagLib::RIFF::WAV

  FORMAT_UNKNOWN = 0x0000 # @since 1.0.0
  FORMAT_PCM     = 0x0001 # @since 1.0.0

  # The file class for `.wav` files.
  #
  # @example Reading the title
  #   title = TagLib::RIFF::WAV::File.open("sample.wav") do |file|
  #     file.tag.title
  #   end
  #
  # @example Reading WAV-specific audio properties
  #   TagLib::RIFF::WAV::File.open("sample.wav") do |file|
  #     file.audio_properties.sample_width  #=>  16
  #   end
  #
  # @example Saving ID3v2 cover-art to disk
  #   TagLib::RIFF::WAV::File.open("sample.wav") do |file|
  #     id3v2_tag = file.tag
  #     cover = id3v2_tag.frame_list('APIC').first
  #     ext = cover.mime_type.rpartition('/')[2]
  #     File.open("cover-art.#{ext}", "wb") { |f| f.write cover.picture }
  #   end
  #
  # @see ID3v2::Tag ID3v2 examples.
  #
  class File < TagLib::File

    NoTags  = 0x0000
    ID3v1   = 0x0001
    ID3v2   = 0x0002
    APE     = 0x0004
    AllTags = 0xffff

    # {include:::TagLib::FileRef.open}
    #
    # @param (see #initialize)
    # @yield [file] the {File} object, as obtained by {#initialize}
    # @return the return value of the block
    #
    def self.open(filename, read_properties=true)
    end

    # Load a WAV file.
    #
    # @param [String] filename
    # @param [Boolean] read_properties if audio properties should be
    #                  read
    def initialize(filename, read_properties=true)
    end

    # Returns the ID3v2 tag.
    #
    # @return [TagLib::ID3v2::Tag]
    def tag
    end

    # Returns the ID3v2 tag.
    #
    # @return [TagLib::ID3v2::Tag]
    #
    # @since 1.0.0
    def id3v2_tag
    end

    # Returns audio properties.
    #
    # @return [TagLib::RIFF::WAV::Properties]
    def audio_properties
    end

    # Remove the tags matching the specified OR-ed types.
    #
    # @param [int] tags The types of tags to remove.
    # @return [void]
    #
    # @since 1.0.0
    def strip(tags=TagLib::RIFF::WAV::File::AllTags)
    end

  end

  class Properties < TagLib::AudioProperties
    # @return [Integer] Number of bits per audio sample.
    #
    # @since 1.0.0
    attr_reader :bits_per_sample

    # @return [Integer] Number of sample frames.
    #
    # @since 1.0.0
    attr_reader :sample_frames

    # @return [Integer] length of the file in seconds
    #
    # @since 1.0.0
    attr_reader :length_in_seconds

    # @return [Integer] length of the file in milliseconds
    #
    # @since 1.0.0
    attr_reader :length_in_milliseconds

    # @return [Integer] The format ID of the file.
    #
    # 0 for unknown, 1 for PCM, 2 for ADPCM, 3 for 32/64-bit IEEE754, and
    # so forth. For further information, refer to the WAVE Form
    # Registration Numbers in RFC 2361.
    #
    # @since 1.0.0
    attr_reader :format
  end

end
