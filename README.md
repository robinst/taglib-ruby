taglib-ruby
===========

Ruby interface for the [TagLib C++ library][taglib], for reading and
writing meta-data (tags) of many audio formats.

In contrast to other libraries, this one wraps the full C++ API, not
only the minimal C API. This means that all tag data can be accessed,
e.g. cover art of ID3v2 or custom fields of Ogg Vorbis comments.

taglib-ruby currently supports the following:

* Reading/writing common tag data of all formats that TagLib supports
* Reading/writing ID3v1 and ID3v2 including ID3v2.4 and Unicode
* Reading/writing Ogg Vorbis comments
* Reading/writing MP4 tags (.m4a)
* Reading audio properties (e.g. bitrate) of the above formats

Contributions for more coverage of the library are very welcome.

[![Gem version][gem-img]][gem-link]
[![Build status][travis-img]][travis-link]

Installation
------------

Before you install the gem, make sure to have [taglib 1.11.1 or higher][taglib] installed
with header files (and a C++ compiler of course):

* Debian/Ubuntu: `sudo apt-get install libtag1-dev`
* Fedora/RHEL: `sudo dnf install taglib-devel`
* Brew: `brew install taglib`
* MacPorts: `sudo port install taglib`

Then do:

    gem install taglib-ruby

### OS X C++ compiler override

Not all versions of TagLib get along with `clang++`, the default C++ compiler
on OS X. To compile taglib-ruby's C++ extensions with a different compiler
during installation, set the `TAGLIB_RUBY_CXX` environment variable.

    TAGLIB_RUBY_CXX=g++-4.2 gem install taglib-ruby

Usage
-----

Complete API documentation can be found on
[rubydoc.info](http://rubydoc.info/gems/taglib-ruby/frames).

Begin with the {TagLib} namespace.

Release Notes
-------------

See {file:CHANGELOG.md}.

Contributing
------------

### Dependencies

Fedora:

    sudo dnf install taglib-devel ruby-devel gcc-c++ redhat-rpm-config swig

### Building

Install dependencies (uses bundler, install it via `gem install bundler`
if you don't have it):

    bundle install

Regenerate SWIG wrappers if you made changes in `.i` files (use version 3.0.7 of SWIG - 3.0.8 through 3.0.12 will not work):

    rake swig

Force regeneration of all SWIG wrappers:

    touch ext/*/*.i
    rake swig

Compile extensions:

    rake clean compile

Run tests:

    rake test

Run irb with library:

    irb -Ilib -rtaglib

Build and install gem into system gems:

    rake install

Build a specific version of Taglib:

    PLATFORM=x86_64-linux TAGLIB_VERSION=1.11.1 rake vendor

The above command will automatically download Taglib 1.11.1, build it and install it in `tmp/x86_64-linux/taglib-1.11.1`.

The `swig` and `compile` tasks can then be executed against that specific version of Taglib by setting the `TAGLIB_DIR` environment variable to `$PWD/tmp/x86_64-linux/taglib-1.11.1` (it is assumed that taglib headers are located at `$TAGLIB_DIR/include` and taglib libraries at `$TAGLIB_DIR/lib`).

The `test` task can then be run for that version of Taglib by adding `$PWD/tmp/x86_64-linux/taglib-1.11.1/lib` to the `LD_LIBRARY_PATH` environment variable.

To do everything in one command:

    PLATFORM=x86_64-linux TAGLIB_VERSION=1.11.1 TAGLIB_DIR=$PWD/tmp/x86_64-linux/taglib-1.11.1 LD_LIBRARY_PATH=$PWD/tmp/x86_64-linux/taglib-1.11.1/lib rake vendor compile test

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

Copyright (c) 2010-2020 Robin Stocker and others, see Git history.

taglib-ruby is distributed under the MIT License,
see LICENSE.txt for details.

In the binary gem for Windows, a compiled [TagLib][taglib] is bundled as
a DLL. TagLib is distributed under the GNU Lesser General Public License
version 2.1 (LGPL) and Mozilla Public License (MPL).

[taglib]: http://taglib.github.io/
[gem-img]: https://badge.fury.io/rb/taglib-ruby.svg
[gem-link]: https://rubygems.org/gems/taglib-ruby
[travis-img]: https://api.travis-ci.org/robinst/taglib-ruby.png
[travis-link]: https://travis-ci.org/robinst/taglib-ruby
