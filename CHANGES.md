Changes in Releases of taglib-ruby
==================================

## 0.5.0 (2012-04-15)

* Add support for FLAC
* Fix problem in SWIG causing compilation error on MacRuby (#10)

## 0.4.0 (2012-03-18)

* Pre-compiled binary gem for Windows (Ruby 1.9) with TagLib 1.7.1
* Unicode filename support on Windows
* Add `open` class method to `FileRef` and `File` classes (use it
  instead of `new` and `close`):

```ruby
title = TagLib::FileRef.open("file.mp3") do |file|
  tag = file.tag
  tag.title
end
```

## 0.3.1 (2012-01-22)

* Fix ObjectPreviouslyDeleted exception after calling
  TagLib::ID3v2::Tag#add_frame (#8)
* Make installation under MacPorts work out of the box (#7)

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
