module TagLib::ID3v1
  # An ID3v1 tag.
  class Tag < TagLib::Tag
    # @return [Integer] the genre as a number
    # @return [255] if not present
    #
    # @since 1.0.0
    attr_accessor :genre_number
  end

  # @return [Array<String>] the ID3v1 genre list.
  #
  # @since 1.0.0
  def genre_list
  end

  # @return [Map<String, int>] the map associating a genre to its index.
  #
  # @since 1.0.0
  def genre_map
  end

  # @return [String] the name of genre at `index` in the ID3v1 genre list.
  #
  # @since 1.0.0
  def genre(index)
  end

  # @return [String] the genre index for the (case sensitive) genre `name`.
  #
  # @since 1.0.0
  def genre_index(name)
  end
end
