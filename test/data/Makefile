.PHONY: all clean

all:: add-relative-volume id3v1-create vorbis-create flac-create mp4-create wav-create wav-dump

add-relative-volume: add-relative-volume.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

id3v1-create: id3v1-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

vorbis-create: vorbis-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

flac-create: flac-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

mp4-create: mp4-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

wav-create: wav-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

wav-dump: wav-dump.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

clean::
	-rm add-relative-volume id3v1-create vorbis-create flac-create mp4-create wav-create wav-dump
