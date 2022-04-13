Changes in Releases of taglib-ruby
==================================

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 1.1.2 - 2022-04-13
### Fixed
- Fix UserTextIdentificationFrame's constructor so that overloaded
  variants with StringList arguments can be called (#107)

## 1.1.1 - 2022-04-12
### Changed
- Fixed build time warnings with Ruby >= 2.7.0 (#85)
- Upgraded to SWIG 4.0.2
- Fixed running tests against TagLib 1.12

## 1.1.0 - 2021-01-20
### Added
- Added support for CTOC and CHAP frames for ID3v2

## 1.0.1 - 2020-03-25

### Fixed
- Fix segmentation fault with TagLib::FLAC picture lists (#91), thanks
  @jameswyper!

## 1.0.0 - 2020-01-07

* Support for TagLib >= 1.11.1 (drop support for earlier versions) (#83)
  * This includes a lot of new APIs and some changed APIs, see
    `@since 1.0.0` in the docs
* Stop using tainted strings to fix warnings with Ruby 2.7 (#86)

## 0.7.1 - 2015-12-28

* Fix compile error during gem installation on Ruby 2.3 (MRI) (#67)

## 0.7.0 - 2014-08-21

* Add support for TagLib::RIFF::AIFF (#52, by @tchev)
* Add support for TagLib::RIFF::WAV (#57, by @tchev)
* Associate filesystem encoding to filename strings
* Allow CXX override during gem installation
* Try to detect location of vendor/taglib on Heroku (#28)
* Documentation updates

## 0.6.0 - 2013-04-26

* Add support for TagLib::MP4 (#3, by @jacobvosmaer)
* Add support for TagLib::ID3v2::Header (#19, by @kaethorn)
* Support saving ID3v2.3 with TagLib::MPEG::File#save (#17)
  *  Note that this requires at least TagLib 1.8, and due to 1.8.0
     having an incorrect version number in the headers, it currently
     requires master. See issue #17 for details.
* Fix segfault when passing a non-String to a String argument
* Documentation updates

## 0.5.2 - 2012-10-06

* Fix memory bug with TagLib::MPEG::File#tag and TagLib::FLAC::File#tag
  which could cause crashes (#14)
* Update TagLib of binary gem for Windows to 1.8

## 0.5.1 - 2012-06-16

* Fix crashes (segfault) with nil arguments, e.g. with `tag.title = nil`
* Document TagLib::MPEG::File#save and TagLib::MPEG::File#strip (#11)
* Update TagLib of binary gem for Windows to 1.7.2

## 0.5.0 - 2012-04-15

* Add support for FLAC
* Fix problem in SWIG causing compilation error on MacRuby (#10)

## 0.4.0 - 2012-03-18

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

## 0.3.1 - 2012-01-22

* Fix ObjectPreviouslyDeleted exception after calling
  TagLib::ID3v2::Tag#add_frame (#8)
* Make installation under MacPorts work out of the box (#7)

## 0.3.0 - 2012-01-02

* Add support for Ogg Vorbis
* Add support for ID3v1 (#2)
* Add #close to File classes for explicitly releasing resources
* Fix compilation on Windows

## 0.2.1 - 2011-11-05

* Fix compilation error due to missing typedef on some systems (#5)

## 0.2.0 - 2011-10-22

* API documentation
* Add support for:
  * TagLib::AudioProperties and TagLib::MPEG::Properties (#4)
  * TagLib::ID3v2::RelativeVolumeFrame

## 0.1.1 - 2011-09-17

* Add installation instructions and clean up description

## 0.1.0 - 2011-09-17

* Initial release
* Coverage of the following API:
  * TagLib::FileRef
  * TagLib::MPEG::File
  * TagLib::ID3v2::Tag
  * TagLib::ID3v2::Frame and subclasses
