module TagLib
  # Abstract tag base class.
  class Tag
    # @return [String] the album
    attr_accessor :album

    # @return [String] the artist/interpret
    attr_accessor :artist

    # @return [String] the comment
    attr_accessor :comment

    # @return [String] the genre
    attr_accessor :genre

    # @return [String] the title
    attr_accessor :title

    # @return [Integer] the track number, or 0 if it isn't present
    attr_accessor :track

    # @return [Integer] the year, or 0 if it isn't present
    attr_accessor :year

    # @return [Boolean]
    def empty?; end
  end
end
