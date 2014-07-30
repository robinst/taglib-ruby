#include <taglib/taglib.h>
#include <taglib/wavfile.h>
#include <taglib/wavproperties.h>
#include <taglib/attachedpictureframe.h>

using namespace TagLib;


void dump_id3v2(ID3v2::Tag *tag)
{
  if (!tag || tag->isEmpty())
  {
    std::cout << "  NO TAGS" << std::endl;
    return;
  }

  std::cout << "  ID3v2." << tag->header()->majorVersion() << "." << tag->header()->revisionNumber() << std::endl;
  std::cout << "    title:   '" << tag->title() << "'" << std::endl;
  std::cout << "    artist:  '" << tag->artist() << "'" << std::endl;
  std::cout << "    album:   '" << tag->album() << "'" << std::endl;
  std::cout << "    track:   " << tag->track() << std::endl;
  std::cout << "    year:    " << tag->year() << std::endl;
  std::cout << "    genre:   '" << tag->genre() << "'" << std::endl;
  std::cout << "    comment: '" << tag->comment() << "'" << std::endl;

  std::cout << "    Frames" << std::endl;
  const ID3v2::FrameList frameList = tag->frameList();
  for(ID3v2::FrameList::ConstIterator it = frameList.begin(); it != frameList.end(); ++it)
    std::cout << "      " << (*it)->frameID() << " - " << (*it)->toString() << std::endl;

  const ID3v2::FrameList apicList = tag->frameList("APIC");
  for(ID3v2::FrameList::ConstIterator it = apicList.begin(); it != apicList.end(); ++it)
  {
    const ID3v2::AttachedPictureFrame *apic = static_cast<ID3v2::AttachedPictureFrame *>(*it);
    std::cout << "    Picture" << std::endl;
    std::cout << "      type:        " << apic->type() << std::endl;
    std::cout << "      mime_type:   '" << apic->mimeType() << "'" << std::endl;
    std::cout << "      description: '" << apic->description() << "'" << std::endl;
    std::cout << "      size:        " << apic->picture().size() << " bytes" << std::endl;
  }
}

void dump_audio_properties(AudioProperties *properties)
{
  std::cout << "  Audio Properties" << std::endl;
  std::cout << "    length:      " << properties->length() << " (seconds)" << std::endl;
  std::cout << "    bitrate:     " << properties->bitrate() << " (kbits/sec)" << std::endl;
  std::cout << "    sample_rate: " << properties->sampleRate() << " (Hz)" << std::endl;
  std::cout << "    channels:    " << properties->channels() << std::endl;
}

void dump_wav_properties(RIFF::WAV::Properties *properties)
{
  std::cout << "  WAV-specific Properties" << std::endl;
  std::cout << "    sample_width: " << properties->sampleWidth() << " (bits)" << std::endl;
}

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cout << "usage: " << argv[0] << " file.wav" << std::endl;
    exit(1);
  }
  char *filename = argv[1];

  std::cout << "WAV file '" << filename << "'..." << std::endl;

  RIFF::WAV::File file(filename);

  dump_id3v2(file.tag());
  dump_audio_properties(file.audioProperties());
  dump_wav_properties(file.audioProperties());
}

// vim: set filetype=cpp sw=2 ts=2 expandtab:
