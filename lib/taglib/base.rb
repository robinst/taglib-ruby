require 'taglib_base'

module TagLib
  module FileOpenable
    def open(*args)
      file = self.new(*args)
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
