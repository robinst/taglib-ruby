taglib-ruby
===========

Ruby interface for the [TagLib C++ library][taglib].

In contrast to other libraries, this one wraps the full C++ API using
SWIG, not only the minimal C API. This means that all tags can be
accessed.

taglib-ruby is work in progress, here are some of the things still left
to do (contributors very welcome):

* Pre-compiled Gem for Windows
* More coverage of the library besides ID3v2

Installation
------------

Before you install the gem, make sure to have [taglib][taglib] installed
with header files (and a C++ compiler of course):

* Debian/Ubuntu: `sudo apt-get install libtag1-dev`
* Fedora/RHEL: `sudo yum install taglib-devel`
* Brew: `brew install taglib`
* MacPorts: `sudo port install taglib`

Then do:

    gem install taglib-ruby

Usage
-----

Here's an example for reading an ID3v2 tag:

```ruby
require 'taglib'

# Load an ID3v2 tag from a file
file = TagLib::MPEG::File.new("wake_up.mp3")
tag = file.id3v2_tag

# Read basic attributes
tag.title  #=> "Wake Up"
tag.artist  #=> "Arcade Fire"
tag.track  #=> 7

# Access all frames
tag.frame_list.size  #=> 13

# Track frame
track = tag.frame_list('TRCK').first
track.to_s  #=> "7/10"

# Attached picture frame
cover = tag.frame_list('APIC').first
cover.mime_type  #=> "image/jpeg"
cover.picture  #=> "\xFF\xD8\xFF\xE0\x00\x10JFIF..."
```

And here's an example for writing one:

```ruby
file = TagLib::MPEG::File.new("joga.mp3")
tag = file.id3v2_tag

# Write basic attributes
tag.artist = "Björk"
tag.title = "Jóga"

# Add attached picture frame
apic = TagLib::ID3v2::AttachedPictureFrame.new
apic.mime_type = "image/jpeg"
apic.description = "Cover"
apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
apic.picture = File.open("cover.jpg", 'rb'){ |f| f.read }

tag.add_frame(apic)

file.save
```

### Encoding

By default, taglib stores text frames as ISO-8859-1 (Latin-1), if the
text contains only characters that are available in that encoding. If
not (e.g. with Cyrillic, Chinese, Japanese), it prints a warning and
stores the text as UTF-8.

When you already know that you want to store the text as UTF-8, you can
change the default text encoding:

```ruby
frame_factory = TagLib::ID3v2::FrameFactory.instance
frame_factory.default_text_encoding = TagLib::String::UTF8
```

Another option is using the advanced API:

```ruby
title = tag.frame_list('TIT2').first
title.text = "Jóga"
title.text_encoding = TagLib::String::UTF8
```

Release Notes
-------------

See {file:CHANGES.md}.

Contributing
------------

* Check out the latest master to make sure the feature hasn't been
  implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't
  requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it
  in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you
  want to have your own version, or is otherwise necessary, that is
  fine, but please isolate to its own commit so I can cherry-pick around
  it.

License
-------

taglib-ruby is distributed under the MIT License,
see LICENSE.txt for details.

Copyright (c) 2010, 2011 Robin Stocker.

[taglib]: http://developer.kde.org/~wheeler/taglib.html
