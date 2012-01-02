Changes in Releases of taglib-ruby
==================================

## 0.3.0 (2012-01-02)

* Add support for Ogg Vorbis
* Add support for ID3v1 (#2)
* Add #close to File classes for explicitly releasing resources
* Fix compilation on Windows

## 0.2.1 (2011-11-05)

* Fix compilation error due to missing typedef on some systems (#5)

## 0.2.0 (2011-10-22)

* API documentation
* Add support for:
  * TagLib::AudioProperties and TagLib::MPEG::Properties (#4)
  * TagLib::ID3v2::RelativeVolumeFrame

## 0.1.1 (2011-09-17)

* Add installation instructions and clean up description

## 0.1.0 (2011-09-17)

* Initial release
* Coverage of the following API:
  * TagLib::FileRef
  * TagLib::MPEG::File
  * TagLib::ID3v2::Tag
  * TagLib::ID3v2::Frame and subclasses
