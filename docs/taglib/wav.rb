# @since 0.7.0
module TagLib::RIFF::WAV

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
    # {include:TagLib::FileRef.open}
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

    # Returns audio properties.
    #
    # @return [TagLib::RIFF::WAV::Properties]
    def audio_properties
    end

  end

  class Properties < TagLib::AudioProperties
    # @return [Integer] Sample width
    attr_reader :sample_width
  end

end
