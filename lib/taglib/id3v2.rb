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
          casted_frame = frame.cast
          yield casted_frame
          it = it.next
        end
      end
    end
    class Frame
      def cast
        case frame_id
        when "APIC" then to_attached_picture_frame
        when "COMM" then to_comments_frame
        when "GEOB" then to_general_encapsulated_object_frame
        when "POPM" then to_popularimeter_frame
        when "PRIV" then to_private_frame
        when "RVAD" then to_relative_volume_frame
        when "TXXX" then to_user_text_identification_frame
        when /T.../ then to_text_identification_frame
        when "UFID" then to_unique_file_identifier_frame
        when "USLT" then to_unsynchronized_lyrics_frame
        when "WXXX" then to_user_url_link_frame
        when /W.../ then to_url_link_frame
        else self
        end
      end
    end
  end
end
