# frozen-string-literal: true

module TagLib
  module Version
    MAJOR = 1
    MINOR = 1
    PATCH = 3
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
