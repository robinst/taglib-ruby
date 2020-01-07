# @since 0.5.0
module TagLib::FLAC

  # The file class for `.flac` files.
  #
  # Note that Xiph comments is the primary tagging format for FLAC files. When
  # saving a file, if there's not yet a Xiph comment, it is created from
  # existing ID3 tags. ID3 tags will be updated if they exist, but not created
  # automatically.
  #
  # @example Reading Xiph comments
  #   TagLib::FLAC::File.open("file.flac") do |file|
  #     tag = file.xiph_comment
  #     puts tag.title
  #     fields = tag.field_list_map
  #     puts fields['DATE']
  #   end
  #
  # @example Adding a picture
  #   TagLib::FLAC::File.open("file.flac") do |file|
  #     pic = TagLib::FLAC::Picture.new
  #     pic.type = TagLib::FLAC::Picture::FrontCover
  #     pic.mime_type = "image/jpeg"
  #     pic.description = "desc"
  #     pic.width = 90
  #     pic.height = 90
  #     pic.data = File.open("cover.jpg", 'rb') { |f| f.read }
  #
  #     file.add_picture(pic)
  #     file.save
  #   end
  class File < TagLib::File

    NoTags      = 0x0000
    XiphComment = 0x0001
    ID3v1       = 0x0002
    ID3v2       = 0x0004
    AllTags     = 0xffff

    # {include:::TagLib::FileRef.open}
    #
    # @param (see #initialize)
    # @yield [file] the {File} object, as obtained by {#initialize}
    # @return the return value of the block
    def self.open(filename, read_properties=true)
    end

    # Load a FLAC file.
    #
    # @param [String] filename
    # @param [Boolean] read_properties if audio properties should be
    #                  read
    def initialize(filename, read_properties=true)
    end

    # Returns the union of the Xiph comment, ID3v1 and ID3v2 tag.
    #
    # @return [TagLib::Tag]
    def tag
    end

    # Returns the Xiph comment tag.
    #
    # @return [TagLib::Ogg::XiphComment]
    def xiph_comment
    end

    # Returns the ID3v1 tag.
    #
    # @return [TagLib::ID3v1::Tag]
    def id3v1_tag
    end

    # Returns the ID3v2 tag.
    #
    # @return [TagLib::ID3v2::Tag]
    def id3v2_tag
    end

    # Returns audio properties.
    #
    # @return [TagLib::FLAC::Properties]
    def audio_properties
    end

    # Returns an array of the pictures attached to the file.
    #
    # @return [Array<TagLib::FLAC::Picture>]
    def picture_list
    end

    # Remove the specified picture.
    #
    # @param [TagLib::FLAC::Picture] picture
    #
    # @since 1.0.0
    def remove_picture(picture)
    end

    # Remove all pictures.
    #
    # @return [void]
    def remove_pictures
    end

    # Add a picture to the file.
    #
    # @param [TagLib::FLAC::Picture] picture
    # @return [void]
    def add_picture(picture)
    end

    # Remove the tags matching the specified OR-ed types.
    #
    # @param [int] tags The types of tags to remove.
    # @return [void]
    #
    # @since 1.0.0
    def strip(tags=TagLib::FLAC::File::AllTags)
    end

    # @return [Boolean] Whether or not the file on disk actually has a XiphComment.
    #
    # @since 1.0.0
    def xiph_comment?
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
  end

  # FLAC audio properties.
  class Properties < TagLib::AudioProperties
    # @return [Integer] Number of bits per audio sample.
    #
    # @since 1.0.0
    attr_reader :bits_per_sample

    # @return [Integer] Number of sample frames.
    #
    # @since 1.0.0
    attr_reader :sample_frames

    # @return [binary String] MD5 signature of uncompressed audio stream
    #   (binary data)
    attr_reader :signature
  end

  # FLAC picture, e.g. for attaching a cover image to a file.
  #
  # The constants in this class are used for the {#type} attribute.
  class Picture
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

    # Type of the picture, see constants.
    # @return [Picture constant]
    attr_accessor :type

    # MIME type (e.g. `"image/png"`)
    # @return [String]
    attr_accessor :mime_type

    # @return [String]
    attr_accessor :description

    # Picture width in pixels
    # @return [Integer]
    attr_accessor :width

    # Picture height in pixels
    # @return [Integer]
    attr_accessor :height

    # Color depth (in bits-per-pixel)
    # @return [Integer]
    attr_accessor :color_depth

    # Number of colors (for indexed images)
    # @return [Integer]
    attr_accessor :num_colors

    # Picture data
    #
    # Be sure to use a binary string when setting this attribute. In
    # Ruby 1.9, this means reading from a file with `"b"` mode to get a
    # string with encoding `BINARY` / `ASCII-8BIT`.
    #
    # @return [binary String]
    attr_accessor :data

    # Parse the picture data in the FLAC picture block format.
    # @return [Boolean] True if the data has been parsed successfully, false otherwise.
    #
    # @since 1.0.0
    def parse(rawdata)
    end
  end
end
