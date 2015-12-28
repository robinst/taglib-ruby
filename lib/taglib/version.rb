module TagLib
  module Version
    MAJOR = 0
    MINOR = 7
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
