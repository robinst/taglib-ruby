module TagLib::MPEG
  # The file class for `.mp3` and other MPEG files.
  class File < TagLib::File
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

    # Returns the ID3v2 tag.
    #
    # @param create if a new tag should be created when none exists
    # @return [TagLib::ID3v2::Tag]
    # @return [nil] if not present
    def id3v2_tag(create=false)
    end
  end
end
