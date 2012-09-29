taglib-ruby
===========

Ruby interface for the [TagLib C++ library][taglib], for reading and
writing meta-data (tags) of many audio formats.

In contrast to other libraries, this one wraps the full C++ API, not
only the minimal C API. This means that all tag data can be accessed,
e.g. cover art of ID3v2 or custom fields of Ogg Vorbis comments.

taglib-ruby is work in progress, but the following is already available:

* Reading/writing common tag data of all formats that TagLib supports
* Reading/writing ID3v1 and ID3v2 including ID3v2.4 and Unicode
* Reading/writing Ogg Vorbis comments
* Reading audio properties (e.g. bitrate) of the above formats

Some things are still left to do (contributors very welcome):

* More coverage of the library

[![Build status][travis-img]][travis-link]

[![flattr this project][flattr-img]][flattr-link]

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

Complete API documentation can be found here:

http://rubydoc.info/gems/taglib-ruby/frames

Begin with the {TagLib} namespace.

Release Notes
-------------

See {file:CHANGES.md}.

Contributing
------------

### Building

    # Install dependencies
    bundle install
    # Regenerate SWIG wrappers (only necessary if you made changes)
    rake swig
    # Compile extension
    rake clean compile
    # Run tests
    rake test
    # Build and install gem into system gems
    rake install

### Workflow

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

Copyright (c) 2010-2012 Robin Stocker.

taglib-ruby is distributed under the MIT License,
see LICENSE.txt for details.

In the binary gem for Windows, a compiled [TagLib][taglib] is bundled as
a DLL. TagLib is distributed under the GNU Lesser General Public License
version 2.1 (LGPL) and Mozilla Public License (MPL).

[taglib]: http://developer.kde.org/~wheeler/taglib.html
[travis-img]: https://secure.travis-ci.org/robinst/taglib-ruby.png
[travis-link]: http://travis-ci.org/robinst/taglib-ruby
[flattr-img]: http://api.flattr.com/button/flattr-badge-large.png
[flattr-link]: https://flattr.com/submit/auto?user_id=robinst&url=https://github.com/robinst/taglib-ruby&title=taglib-ruby&tags=github&category=software
