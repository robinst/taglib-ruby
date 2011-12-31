module TagLib::Ogg::Vorbis

  # The file class for `.ogg` and other `.oga` files.
  class File < TagLib::Ogg::File
    # Load an Ogg Vorbis file.
    #
    # @param [String] filename
    # @param [Boolean] read_properties if audio properties should be
    #                  read
    def initialize(filename, read_properties=true)
    end

    # Returns the VorbisComment tag.
    #
    # @return [TagLib::Ogg::XiphComment]
    def tag
    end

    # Returns audio properties.
    #
    # @return [TagLib::Ogg::Vorbis::Properties]
    def audio_properties
    end
  end

  # Ogg Vorbis audio properties.
  class Properties < TagLib::AudioProperties
    # @return [Integer] Vorbis version
    attr_reader :vorbis_version

    # @return [Integer] maximum bitrate from Vorbis identification
    #   header
    attr_reader :bitrate_maximum

    # @return [Integer] nominal bitrate from Vorbis identification
    #   header
    attr_reader :bitrate_nominal

    # @return [Integer] minimum bitrate from Vorbis identification
    #   header
    attr_reader :bitrate_minimum
  end
end
