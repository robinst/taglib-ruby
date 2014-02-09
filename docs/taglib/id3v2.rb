module TagLib::ID3v2
  # An ID3v2 tag. A tag consists of a list of frames, identified by IDs.
  #
  # ## Encoding
  #
  # By default, taglib stores ID3v2 text frames as ISO-8859-1 (Latin-1) if the
  # text contains only characters that are available in that encoding. If
  # not (e.g. with Cyrillic, Chinese, Japanese), it prints a warning and
  # stores the text as UTF-8.
  #
  # When you already know that you want to store the text as UTF-8, you can
  # change the default text encoding:
  #
  #     frame_factory = TagLib::ID3v2::FrameFactory.instance
  #     frame_factory.default_text_encoding = TagLib::String::UTF8
  #
  # Another option is using the frame API directly:
  #
  #     title = tag.frame_list('TIT2').first
  #     title.text = "Joga"
  #     title.text_encoding = TagLib::String::UTF8
  #
  # @example Read ID3v2 frames from a file
  #   TagLib::MPEG::File.open("wake_up.mp3") do |file|
  #     tag = file.id3v2_tag
  #
  #     # Read basic attributes
  #     tag.title  #=> "Wake Up"
  #     tag.artist  #=> "Arcade Fire"
  #     tag.track  #=> 7
  #
  #     # Access all frames
  #     tag.frame_list.size  #=> 13
  #
  #     # Track frame
  #     track = tag.frame_list('TRCK').first
  #     track.to_s  #=> "7/10"
  #
  #     # Attached picture frame
  #     cover = tag.frame_list('APIC').first
  #     cover.mime_type  #=> "image/jpeg"
  #     cover.picture  #=> "\xFF\xD8\xFF\xE0\x00\x10JFIF..."
  #   end
  #
  # @example Add frames and save file
  #   TagLib::MPEG::File.open("joga.mp3") do |file|
  #     tag = file.id3v2_tag
  #
  #     # Write basic attributes
  #     tag.artist = "Björk"
  #     tag.title = "Jóga"
  #
  #     # Add attached picture frame
  #     apic = TagLib::ID3v2::AttachedPictureFrame.new
  #     apic.mime_type = "image/jpeg"
  #     apic.description = "Cover"
  #     apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
  #     apic.picture = File.open("cover.jpg", 'rb') { |f| f.read }
  #
  #     tag.add_frame(apic)
  #
  #     file.save
  #   end
  class Tag < TagLib::Tag
    # Get a list of frames.
    #
    # Note that the frames returned are subclasses of {TagLib::ID3v2::Frame},
    # depending on the frame ID. But it's also possible that a
    # {TagLib::ID3v2::UnknownFrame} is returned (e.g. when TagLib discards a
    # deprecated frame). So to make sure your code can handle all the cases, it
    # should include a check for the returned class of the frame.
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
    # @param [Frame] frame
    # @return [void]
    def add_frame(frame)
    end

    # Remove the passed frame from the tag.
    #
    # **Note:** You can and shall not call any methods on the frame
    # object after you have passed it to this method, because the
    # underlying C++ object has been deleted.
    #
    # @param [Frame] frame to remove
    # @return [void]
    def remove_frame(frame)
    end

    # Remove all frames with the specified ID from the tag.
    #
    # **Note:** If you have obtained any frame objects with the same ID
    # from the tag before calling this method, you should not touch them
    # anymore. The reason is that the C++ objects may have been deleted.
    #
    # @param [String] id
    # @return [void]
    def remove_frames(id)
    end
  end

  # Exposes properties defined in a standard ID3v2 header.
  class Header
    # The major version number (4 for a ID3v2.4.0 version tag).
    # @return [Integer] major version number
    attr_accessor :major_version

    # The size of the tag without the size of the header.
    # @return [Integer] size in bytes
    attr_accessor :tag_size

    # The revision version number (0 for a ID3v2.4.0 version tag).
    # @return [Integer] revision version number
    attr_reader :revision_number

    # @return [Boolean] if unsynchronisation has been applied to all frames
    attr_reader :unsynchronisation

    # @return [Boolean] if an extended header is present in the tag
    attr_reader :extended_header

    # @return [Boolean] if the experimental indicator flag is set
    attr_reader :experimental_indicator

    # @return [Boolean] if a footer is present in the tag
    attr_reader :footer_present

    # Renders the header to binary.
    # @return [TagLib::ByteVector]
    def render
    end
  end

  # Frame factory for ID3v2 frames. Useful for setting the default text
  # encoding.
  class FrameFactory
    # @return [FrameFactory] the default frame factory
    def self.instance
    end

    # Get/set the default text encoding for new ID3v2 frames. See the
    # section _String Encodings_ in {TagLib}.
    #
    # @return [TagLib::String constant] default text encoding
    attr_accessor :default_text_encoding
  end

  # The base class for all ID3v2 frames.
  #
  # In ID3v2 all frames are identified by a {#frame_id frame ID}, such
  # as `TIT2` or `APIC`. The data in the frames is different depending
  # on the frame type, which is why there is a subclass for each type.
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
    # @return [String] frame ID
    attr_reader :frame_id

    # @return [String] a subclass-specific string representation
    def to_string
    end
  end

  # Attached picture frame (`APIC`), e.g. for cover art.
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

    # {include:GeneralEncapsulatedObjectFrame#object}
    #
    # @return [binary String]
    attr_accessor :picture

    # {include:TextIdentificationFrame#text_encoding}
    #
    # @return [TagLib::String constant]
    attr_accessor :text_encoding

    # Type of the attached picture, see constants.
    # @return [AttachedPictureFrame constant]
    attr_accessor :type
  end

  # Comments frame (`COMM`) for full text information that doesn't fit in
  # any other frame.
  class CommentsFrame < Frame
    # @return [String] content description, which together with language
    #   should be unique per tag
    attr_accessor :description

    # @return [String] alpha-3 language code of text (ISO-639-2),
    #   e.g. "eng"
    attr_accessor :language

    # @return [String] the actual comment text
    attr_accessor :text

    # {include:TextIdentificationFrame#text_encoding}
    #
    # @return [TagLib::String constant]
    attr_accessor :text_encoding
  end

  # General encapsulated object frame (`GEOB`).
  class GeneralEncapsulatedObjectFrame < Frame
    # @return [String] content description
    attr_accessor :description

    # @return [String] file name
    attr_accessor :file_name

    # @return [String] MIME type
    attr_accessor :mime_type

    # Binary data string.
    #
    # Be sure to use a binary string when setting this attribute. In
    # Ruby 1.9, this means reading from a file with `"b"` mode to get a
    # string with encoding `BINARY` / `ASCII-8BIT`.
    #
    # @return [binary String]
    attr_accessor :object

    # {include:TextIdentificationFrame#text_encoding}
    #
    # @return [String]
    attr_accessor :text_encoding
  end

  # Popularimeter frame (`POPM`).
  class PopularimeterFrame < Frame
    # @return [Integer] play counter
    attr_accessor :counter

    # @return [String] e-mail address
    attr_accessor :email

    # @return [Integer] rating
    attr_accessor :rating
  end

  # Private frame (`PRIV`).
  class PrivateFrame < Frame
    # {include:GeneralEncapsulatedObjectFrame#object}
    #
    # @return [binary String]
    attr_accessor :data

    # @return [String] owner identifier
    attr_accessor :owner
  end

  # Relative volume adjustment frame (`RVAD` or `RVA2`).
  class RelativeVolumeFrame < Frame
    Other        = 0x00
    MasterVolume = 0x01
    FrontRight   = 0x02
    FrontLeft    = 0x03
    BackRight    = 0x04
    BackLeft     = 0x05
    FrontCentre  = 0x06
    BackCentre   = 0x07
    Subwoofer    = 0x08

    # @return [Array<TagLib::ID3v2::RelativeVolumeFrame constant>]
    #   the channel types for which volume adjustment information is
    #   stored in this frame
    def channels
    end

    # @return [String] relative volume identification
    attr_accessor :identification

    # Returns peak volume for channel type.
    #
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [TagLib::ID3v2::PeakVolume]
    def peak_volume(type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end

    # Sets peak volume for channel type.
    #
    # @param [TagLib::ID3v2::PeakVolume] peak peak volume
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [void]
    def set_peak_volume(peak, type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end

    # Returns volume adjustment in decibels for a specific channel type.
    # Internally, this is stored as an index, see
    # {#volume_adjustment_index}.
    #
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [Float]
    def volume_adjustment(type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end

    # Sets volume adjustment in decibels for a specific channel type.
    # Internally, this is stored as an index, see
    # {#set_volume_adjustment_index}.
    #
    # @param [Float] adjustment
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [void]
    def set_volume_adjustment(adjustment, type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end

    # Returns volume adjustment index for a specific channel type. When
    # dividing the index by 512, it corresponds to the volume adjustment
    # in decibel.
    #
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [Integer]
    def volume_adjustment_index(type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end

    # Sets volume adjustment index for a specific channel type. When
    # dividing the index by 512, it corresponds to the volume adjustment
    # in decibel.
    #
    # @param [Integer] index
    # @param [TagLib::ID3v2::RelativeVolumeFrame constant] type
    # @return [void]
    def set_volume_adjustment_index(index, type=TagLib::ID3v2::RelativeVolumeFrame::MasterVolume)
    end
  end

  # Peak volume used for {RelativeVolumeFrame}. The two attributes of
  # this class must always read/written together, as they are used to
  # describe one concept, the peak volume number.
  #
  # Note that due to how SWIG works, this is not a nested class of
  # RelativeVolumeFrame as in taglib. That doesn't affect its usage
  # though.
  class PeakVolume
    # @return [Integer] the number of bits of the {#peak_volume} that
    #   represent the peak volume (0 to 255)
    attr_accessor :bits_representing_peak

    # @return [binary String] the (byte-padded) bits used for the peak
    #   volume
    attr_accessor :peak_volume
  end

  # Text identification frame (`T???`).
  #
  # @example Create a new TIT2 frame
  #   frame = TagLib::ID3v2::TextIdentificationFrame.new("TIT2", TagLib::String::UTF8)
  #   frame.text = "Title"
  class TextIdentificationFrame < Frame
    # @param [String] type the frame ID, e.g. `TDRC`
    # @param [TagLib::String constant] encoding text encoding, e.g. `TagLib::String::UTF8`
    def initialize(type, encoding)
    end

    # Encoding for storing the text in the tag, e.g.
    # `TagLib::String::UTF8`. See the section _String Encodings_ in
    # {TagLib}.
    #
    # @return [TagLib::String constant]
    attr_accessor :text_encoding

    # @return [Array<String>] list of text strings in this frame
    attr_accessor :field_list

    # @param [String] value simple text to set
    attr_writer :text
  end

  # User text identification frame (`TXXX`).
  class UserTextIdentificationFrame < TextIdentificationFrame
    # @return [String] description of content
    attr_accessor :description
  end

  # Unique file identifier frame (`UFID`).
  class UniqueFileIdentifierFrame < Frame
    # @return [String] identifier
    attr_accessor :identifier

    # @return [String] owner
    attr_accessor :owner
  end

  # Unknown frame used by TagLib to represent a frame whose type is not
  # known, not implemented or deprecated in later versions of ID3v2.
  class UnknownFrame < Frame
  end

  # Unsynchronized lyrics frame (`USLT`).
  class UnsynchronizedLyricsFrame < Frame
    # @return [String] frame description
    attr_accessor :description

    # @return [String] alpha-3 language code of text (ISO-639-2),
    #   e.g. "eng"
    attr_accessor :language

    # @return [String] text
    attr_accessor :text

    # {include:TextIdentificationFrame#text_encoding}
    #
    # @return [String]
    attr_accessor :text_encoding
  end

  # URL link frame (`W???`), e.g. `WOAR` for "official artist/performer
  # webpage".
  class UrlLinkFrame < Frame
    # @param [String] value simple text to set
    attr_writer :text

    # @param [String] value URL
    attr_accessor :url
  end

  # User URL link frame (`WXXX`).
  class UserUrlLinkFrame < UrlLinkFrame
    # @return [String] description
    attr_accessor :description

    # {include:TextIdentificationFrame#text_encoding}
    #
    # @return [String]
    attr_accessor :text_encoding
  end
end
