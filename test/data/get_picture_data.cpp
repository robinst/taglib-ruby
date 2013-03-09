#include <fstream>

using namespace TagLib;

ByteVector getPictureData(const char *filename) {
  std::ifstream is;
  is.open(filename, std::ios::binary);

  is.seekg(0, std::ios::end);
  int length = is.tellg();
  is.seekg(0, std::ios::beg);

  char *buffer = new char[length];

  is.read(buffer, length);
  is.close();

  ByteVector result(buffer, length);
  delete[] buffer;

  return result;
}
