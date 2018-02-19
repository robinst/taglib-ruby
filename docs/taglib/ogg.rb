module TagLib::Ogg

  # @abstract Base class for Ogg files, see subclasses.
  class File < TagLib::File
  end

  # Xiph comments (aka VorbisComment), a metadata format used for Ogg
  # Vorbis and other codecs.
  #
  # A Xiph comment is structured as a set of fields. Each field has a
  # name and a value. Multiple fields with the same name are allowed, so
  # you can also view it as a map from names to a list of values.
  class XiphComment < TagLib::Tag

    # Add a name-value pair to the comment.
    #
    # @param [String] name field name
    # @param [String] value field value
    # @param [Boolean] replace if true, all existing fields with the
    #   given name will be replaced
    # @return [void]
    def add_field(name, value, replace=true)
    end

    # Check if the comment contains a field.
    #
    # @param [String] name field name
    # @return [Boolean]
    def contains?(name)
    end

    # Count the number of fields.
    #
    # @return [Integer] the number of fields in the comment (name-value
    #   pairs)
    def field_count
    end

    # Get the contents of the comment as a hash, with the key being a
    # field name String and the value a list of field values for that
    # key. Example result:
    #
    #     { 'TITLE' => ["Title"],
    #       'GENRE' => ["Rock", "Pop"] }
    #
    # Note that the returned hash is read-only. Changing it will have no
    # effect on the comment; use {#add_field} and {#remove_field} for
    # that.
    #
    # Starting with TagLib 1.11, pictures stored in the COVERART field,
    # which is a deprecated way to store attached pictures ([reference][coverart_ref]),
    # will be reported as being part of the METADATA_BLOCK_PICTURE field
    # and will be converted to this format on save.
    #
    # [coverart_ref]: https://wiki.xiph.org/VorbisComment#Unofficial_COVERART_field_.28deprecated.29
    #
    # @return [Hash<String, Array<String>>] a hash from field names to
    #   value lists
    def field_list_map
    end

    # Remove one or more fields.
    #
    # @overload remove_field(name)
    #   Removes all fields with the given name.
    #
    #   @param [String] name field name
    #
    # @overload remove_field(name, value)
    #   Removes the field with the given name and value.
    #
    #   @param [String] name field name
    #   @param [String] value field value
    #
    # @return [void]
    def remove_field
    end

    # @return [String] vendor ID of the encoder used
    attr_reader :vendor_id

  end

end
