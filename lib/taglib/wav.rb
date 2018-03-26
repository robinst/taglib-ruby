require 'taglib_wav'

module TagLib::RIFF::WAV

  FORMAT_UNKNOWN = 0x0000
  FORMAT_PCM     = 0x0001

  class File
    extend ::TagLib::FileOpenable
  end
end
