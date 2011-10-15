require 'taglib_id3v2'

module TagLib
  module ID3v2
    class Frame
      def to_s
        to_string
      end

      def inspect
        # Overwrite inspect because Object#inspect calls to_s. In case
        # of an unlinked frame, calling to_s would lead to calling into
        # SWIG through to_string, which in turn would raise an exception
        # with a message including an inspect of this object, which
        # would call to_s -> stack overflow.
        "#<%s:0x%x>" % [self.class.to_s, object_id << 1]
      end
    end
  end
end
