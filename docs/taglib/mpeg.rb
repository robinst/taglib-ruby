module TagLib::MPEG
  # The file class for `.mp3` and other MPEG files.
  #
  # @example Reading a title
  #   title = TagLib::MPEG::File.open("file.mp3") do |file|
  #     tag = file.tag
  #     tag.title
  #   end
  #
  class File < TagLib::File
    # {include:TagLib::FileRef.open}
    #
    # @param (see #initialize)
    # @yield [file] the {File} object, as obtained by {#initialize}
    # @return the return value of the block
    #
    # @since 0.4.0
    def self.open(filename, read_properties=true)
    end

    # Load an MPEG file.
    #
    # @param [String] filename
    # @param [Boolean] read_properties if audio properties should be
    #                  read
    def initialize(filename, read_properties=true)
    end

    # Returns a tag that contains attributes from both the ID3v2 and
    # ID3v1 tag, with ID3v2 attributes having precendence.
    #
    # @return [TagLib::Tag]
    # @return [nil] if not present
    def tag
    end

    # Returns the ID3v1 tag.
    #
    # @param create if a new tag should be created when none exists
    # @return [TagLib::ID3v1::Tag]
    # @return [nil] if not present
    def id3v1_tag(create=false)
    end

    # Returns the ID3v2 tag.
    #
    # @param create if a new tag should be created when none exists
    # @return [TagLib::ID3v2::Tag]
    # @return [nil] if not present
    def id3v2_tag(create=false)
    end

    # Returns audio properties.
    #
    # @return [TagLib::MPEG::Properties]
    def audio_properties
    end
  end

  # Audio properties for MPEG files.
  class Properties < TagLib::AudioProperties
    # @return [TagLib::MPEG::XingHeader] Xing header
    # @return [nil] if not present
    def xing_header
    end

    # @return [TagLib::MPEG::Header constant] MPEG version,
    #   e.g. {TagLib::MPEG::Header::Version1}
    def version
    end

    # @return [Integer] MPEG layer (1-3)
    def layer
    end

    # @return [true] if MPEG protection bit is set
    def protection_enabled
    end

    # @return [TagLib::MPEG::Header constant] channel mode,
    #   e.g. {TagLib::MPEG::Header::JointStereo}
    def channel_mode
    end

    # @return [true] if copyrighted bit is set
    def copyrighted?
    end

    # @return [true] if original bit is set
    def original?
    end
  end

  # MPEG header.
  class Header
    Version1 = 0
    Version2 = 1
    Version2_5 = 2

    Stereo = 0
    JointStereo = 1
    DualChannel = 2
    SingleChannel = 3
  end

  # Xing VBR header.
  class XingHeader
    # @return [true] if a valid Xing header is present
    def valid?
    end

    # @return [Integer] total number of frames
    def total_frames
    end

    # @return [Integer] total size of stream in bytes
    def total_size
    end
  end
end
