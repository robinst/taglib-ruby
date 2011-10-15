module TagLib::ID3v2
  # An ID3v2 tag.
  class Tag < TagLib::Tag
    # Get a list of frames. Note that the frames returned are subclasses
    # of {TagLib::ID3v2::Frame}, depending on the frame ID.
    #
    # @overload frame_list()
    #   Returns all frames.
    #
    # @overload frame_list(frame_id)
    #   Returns frames matching ID.
    #
    #   @param [String] frame_id Specify this parameter to get only the
    #     frames matching a frame ID (e.g. "TIT2").
    #
    # @return [Array<TagLib::ID3v2::Frame>]
    def frame_list
    end

    # Add a frame to the tag.
    #
    # @param [Frame]
    # @return [void]
    def add_frame(frame)
    end
  end

  # The base class for all ID3v2 frames.
  #
  # In ID3v2 all frames are identified by a frame ID, such as `TIT2` or
  # `APIC`. The data in the frames is different depending on the frame
  # type, which is why there is a subclass for each type.
  #
  # The most common frame type is the text identification frame. All
  # frame IDs of this type begin with `T`, for example `TALB` for the
  # album. See {TextIdentificationFrame}.
  #
  # Then there are the URL link frames, which begin with `W`, see
  # {UrlLinkFrame}.
  #
  # Finally, there are some specialized frame types and their
  # corresponding classes:
  #
  # * `APIC`: {AttachedPictureFrame}
  # * `COMM`: {CommentsFrame}
  # * `GEOB`: {GeneralEncapsulatedObjectFrame}
  # * `POPM`: {PopularimeterFrame}
  # * `PRIV`: {PrivateFrame}
  # * `RVAD`: {RelativeVolumeFrame}
  # * `TXXX`: {UserTextIdentificationFrame}
  # * `UFID`: {UniqueFileIdentifierFrame}
  # * `USLT`: {UnsynchronizedLyricsFrame}
  # * `WXXX`: {UserUrlLinkFrame}
  #
  class Frame
    # @return [String] a subclass-specific string representation
    def to_string
    end
  end

  # Attached picture frame, e.g. for cover art.
  #
  # The constants in this class are used for the {#type} attribute.
  class AttachedPictureFrame < Frame
    # Other
    Other              = 0x00
    # 32x32 file icon (PNG only)
    FileIcon           = 0x01
    OtherFileIcon      = 0x02
    FrontCover         = 0x03
    BackCover          = 0x04
    LeafletPage        = 0x05
    Media              = 0x06
    LeadArtist         = 0x07
    Artist             = 0x08
    Conductor          = 0x09
    Band               = 0x0A
    Composer           = 0x0B
    Lyricist           = 0x0C
    RecordingLocation  = 0x0D
    DuringRecording    = 0x0E
    DuringPerformance  = 0x0F
    MovieScreenCapture = 0x10
    ColouredFish       = 0x11
    Illustration       = 0x12
    BandLogo           = 0x13
    PublisherLogo      = 0x14

    def initialize()
    end

    # @return [String]
    attr_accessor :description

    # MIME type (e.g. `"image/png"`)
    # @return [String]
    attr_accessor :mime_type

    # Binary picture data string. Be sure to use a binary string when
    # setting this attribute. In Ruby 1.9, this means reading from a
    # file with `"b"` mode to get a string with encoding
    # `BINARY` / `ASCII-8BIT`.
    #
    # @return [String]
    attr_accessor :picture

    # Text encoding for storing the description in the tag, see the
    # section _String Encodings_ in {TagLib}.
    #
    # @return [TagLib::String constant]
    attr_accessor :text_encoding

    # Type of the attached picture, see constants.
    # @return [AttachedPictureFrame constant]
    attr_accessor :type
  end

  class CommentsFrame < Frame
  end

  class GeneralEncapsulatedObjectFrame < Frame
  end

  class PopularimeterFrame < Frame
  end

  class PrivateFrame < Frame
  end

  class RelativeVolumeFrame < Frame
  end

  class TextIdentificationFrame < Frame
  end

  class UserTextIdentificationFrame < TextIdentificationFrame
  end

  class UniqueFileIdentifierFrame < Frame
  end

  class UnsynchronizedLyricsFrame < Frame
  end

  class UrlLinkFrame < Frame
  end

  class UserUrlLinkFrame < UrlLinkFrame
  end
end
