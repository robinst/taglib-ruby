require 'taglib_id3v2'

module TagLib
  module ID3v2
    class FrameList
      include Enumerable

      def each
        it = self.begin
        it_end = self.end
        while it != it_end
          frame = it.value
          yield frame
          it = it.next
        end
      end
    end
    class Frame
      def id
        frame_id.data[0, frame_id.size]
      end
    end
  end
end
