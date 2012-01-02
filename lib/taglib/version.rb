module TagLib
  module Version
    MAJOR = 0
    MINOR = 3
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
