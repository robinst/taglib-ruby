# @since 0.7.0
module TagLib::RIFF::AIFF

  # The file class for `.aiff` files.
  #
  # @example Reading a title
  #   title = TagLib::RIFF::AIFF::File.open("file.aiff") do |file|
  #     tag = file.tag
  #     tag.title
  #   end
  #
  # @example Reading the sample width
  #   TagLib::RIFF::AIFF::File.open("file2.aif") do |file|
  #     file.audio_properties.sample_width  #=>  16
  #   end
  #
  # @example Saving cover-art to disk
  #   TagLib::RIFF::AIFF::File.open("file.aiff") do |file|
  #     cover = file.tag.frame_list('APIC').first
  #     ext = cover.mime_type.rpartition('/')[2]
  #     File.open("cover-art.#{ext}", "wb") { |f| f.write cover.picture }
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

  end

  class Properties < TagLib::AudioProperties
    # @return [Integer] Sample width
    attr_reader :sample_width
  end

end
