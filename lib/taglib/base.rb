require 'taglib_base'

module TagLib
  class ByteVector
    def bytes
      data[0, size]
    end
  end
end
