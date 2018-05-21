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

    # Save the file and the associated tags.
    #
    # @overload save(tags=TagLib::MPEG::File::AllTags, strip_others=true)
    #
    #   @param [Integer] tags
    #     The tag types to save (see constants), e.g.
    #     {TagLib::MPEG::File::ID3v2}. To specify more than one tag type,
    #     or them together using `|`, e.g.
    #     `TagLib::MPEG::File::ID3v1 | TagLib::MPEG::File::ID3v2`.
    #   @param [Boolean] strip_others
    #     true if tag types other than the specified ones should be
    #     stripped from the file
    #
    # @overload save(tags, strip_others, id3v2_version)
    #
    #   @param [Integer] id3v2_version
    #     3 if the saved ID3v2 tag should be in version ID3v2.3, or 4 if
    #     it should use ID3v2.4
    #
    #   This overload can only be called if the extension was compiled
    #   against TagLib >= 1.8. Otherwise it will raise an ArgumentError.
    #   So either check the version using {TagLib::TAGLIB_MAJOR_VERSION}
    #   and {TagLib::TAGLIB_MINOR_VERSION} or be prepared to rescue the
    #   ArgumentError.
    #
    # @return [Boolean] whether saving was successful
    def save(tags=TagLib::MPEG::File::AllTags, strip_others=true)
    end

    # Strip the specified tags from the file. Note that this directly
    # updates the file, a call to save afterwards is not necessary
    # (closing the file is necessary as always, though).
    #
    # @param [Integer] tags
    #   The tag types to strip (see constants), e.g.
    #   {TagLib::MPEG::File::ID3v2}. To specify more than one tag type,
    #   or them together using `|`, e.g.
    #   `TagLib::MPEG::File::ID3v1 | TagLib::MPEG::File::ID3v2`.
    # @return [Boolean] whether stripping was successful
    def strip(tags=TagLib::MPEG::File::AllTags)
    end

    # @return [Boolean] Whether or not the file on disk actually has an ID3v1 tag.
    #
    # @since 1.0.0
    def id3v1_tag?
    end

    # @return [Boolean] Whether or not the file on disk actually has an ID3v2 tag.
    #
    # @since 1.0.0
    def id3v2_tag?
    end

    # @return [Boolean] Whether or not the file on disk actually has an APE tag.
    #
    # @since 1.0.0
    def ape_tag?
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

    Invalid = 0
    Xing    = 1
    VBRI    = 2

    # @return [true] if a valid Xing header is present
    def valid?
    end

    # @return [Integer] total number of frames
    def total_frames
    end

    # @return [Integer] total size of stream in bytes
    def total_size
    end

    # @return [Integer] the type of the VBR header.
    #
    # @since 1.0.0
    def type
    end
  end
end
