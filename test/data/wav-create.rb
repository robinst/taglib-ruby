require '/home/tchevereau/tch/Dev/voxtok/lib/tchev/taglib-ruby/lib/taglib'

sample = 'wav-sample.wav'
coverart = 'globe_east_540.jpg'
thumbnail = 'globe_east_90.jpg'

def dump(sample)
  puts "dump file '#{sample}'..."

  TagLib::RIFF::WAV::File.open(sample) do |file|

    if file.tag and not file.tag.empty?
      puts "  ID3v2 tags"
      puts "    title:   '#{file.tag.title}'"
      puts "    album:   '#{file.tag.album}'"
      puts "    artist:  '#{file.tag.artist}'"
      puts "    track:   #{file.tag.track}"
      puts "    year:    #{file.tag.year}"
      puts "    genre:   '#{file.tag.genre}'"
      puts "    comment: '#{file.tag.comment}'"

      puts "    frames"
      file.tag.frame_list.each_with_index do |frame, index|
        puts "      #{index} - #{frame.frame_id} - #{frame.to_string}"
      end

      file.tag.frame_list('APIC').each_with_index do |apic, index|
        puts "    picture #{index}"
        puts "      type:        #{apic.type}"
        puts "      mime_type:   '#{apic.mime_type}'"
        puts "      description: '#{apic.description}'"
        puts "      size:        #{apic.picture.size} bytes"
      end

    else
      puts "  NO TAGS"
    end

    if file.audio_properties
      puts "  Audio Properties"
      puts "    length:       #{file.audio_properties.length} (seconds)"
      puts "    bitrate:      #{file.audio_properties.bitrate} (kbits/sec)"
      puts "    sample_rate:  #{file.audio_properties.sample_rate} (Hz)"
      puts "    channels:     #{file.audio_properties.channels}"
      puts "  WAV-specific Audio Properties"
      puts "    sample_width: #{file.audio_properties.sample_width} (bits)"
    else
      puts "  NO AUDIO PROPERTIES"
    end

  end
  puts ""
end

def update(sample, coverart, thumbnail)
  puts "update file '#{sample}'..."

  TagLib::RIFF::WAV::File.open(sample) do |file|

    file.tag.artist = 'WAV Dummy Artist Name'
    file.tag.album = 'WAV Dummy Album Title'
    file.tag.title = 'WAV Dummy Track Title'
    file.tag.track = 5
    file.tag.year = 2014
    file.tag.genre = 'Jazz'
    file.tag.comment = 'WAV Dummy Comment'

    file.tag.remove_frames('APIC')

    picture = File.open(coverart, 'rb') { |f| f.read }
    apic = TagLib::ID3v2::AttachedPictureFrame.new
    apic.picture = picture
    apic.mime_type = "image/jpeg"
    apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
    apic.description = "WAV Dummy Front Cover-Art"
    apic.text_encoding = TagLib::String::UTF8
    file.tag.add_frame(apic)

    picture = File.open(thumbnail, 'rb') { |f| f.read }
    apic = TagLib::ID3v2::AttachedPictureFrame.new
    apic.picture = picture
    apic.mime_type = "image/jpeg"
    apic.type = TagLib::ID3v2::AttachedPictureFrame::Other
    apic.description = "WAV Dummy Thumbnail"
    apic.text_encoding = TagLib::String::UTF8
    file.tag.add_frame(apic)

    file.save
  end

  puts "done."
  puts ""
end


puts ""
puts "file '#{sample}'..."
puts ""

dump sample
update sample, coverart, thumbnail
dump sample

puts "terminated."
