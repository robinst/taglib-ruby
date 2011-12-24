.PHONY: all clean

all:: add-relative-volume id3v1-create

add-relative-volume: add-relative-volume.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

id3v1-create: id3v1-create.cpp
	g++ -o $@ $< -ltag -I/usr/include/taglib

clean::
	-rm add-relative-volume id3v1-create
