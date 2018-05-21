# @since 0.7.0
module TagLib::RIFF::AIFF

  # The file class for `.aiff` files.
  #
  # @example Reading the title
  #   title = TagLib::RIFF::AIFF::File.open("sample.aiff") do |file|
  #     file.tag.title
  #   end
  #
  # @example Reading AIFF-specific audio properties
  #   TagLib::RIFF::AIFF::File.open("sample.aiff") do |file|
  #     file.audio_properties.sample_width  #=>  16
  #   end
  #
  # @example Saving ID3v2 cover-art to disk
  #   TagLib::RIFF::AIFF::File.open("sample2.aif") do |file|
  #     id3v2_tag = file.tag
  #     cover = id3v2_tag.frame_list('APIC').first
  #     ext = cover.mime_type.rpartition('/')[2]
  #     File.open("cover-art.#{ext}", "wb") { |f| f.write cover.picture }
  #   end
  #
  # @see ID3v2::Tag ID3v2 examples.
  #
  class File < TagLib::File
    # {include:::TagLib::FileRef.open}
    #
    # @param (see #initialize)
    # @yield [file] the {File} object, as obtained by {#initialize}
    # @return the return value of the block
    #
    def self.open(filename, read_properties=true)
    end

    # Load an AIFF file.
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

    # Returns audio properties.
    #
    # @return [TagLib::RIFF::AIFF::Properties]
    def audio_properties
    end

    # @return [Boolean] Whether or not the file on disk actually has an ID3v2 tag.
    #
    # @since 1.0.0
    def id3v2_tag?
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

    # @return [String] The compression type of the AIFF-C file.
    # For example, "NONE" for not compressed, "ACE2" for ACE 2-to-1.
    # If the file is in AIFF format, always returns an empty string.
    #
    # @since 1.0.0
    attr_reader :compression_type

    # @return [String] Returns the concrete compression name of the AIFF-C file.
    # If the file is in AIFF format, always returns an empty string.
    #
    # @since 1.0.0
    attr_reader :compression_name

    # @return [Boolean] True if the file is in AIFF-C format, false if AIFF format.
    #
    # @since 1.0.0
    def aiff_c?
    end
  end

end
