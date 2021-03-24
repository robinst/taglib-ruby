# frozen-string-literal: true

require 'taglib_base'

module TagLib
  module FileOpenable
    def open(*args)
      file = new(*args)
      begin
        result = yield file
      ensure
        file.close
      end
      result
    end
  end

  class FileRef
    extend FileOpenable
  end
end
