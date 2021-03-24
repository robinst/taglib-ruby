# frozen-string-literal: true

require File.join(File.dirname(__FILE__), 'helper')

class TestFlacPictureMemory < Test::Unit::TestCase
  N = 10000

  context 'TagLib::FLAC::Picture' do
    setup do
    end

    should 'release memory when closing flac file with picture data' do
      c = 0
      N.times do
        TagLib::FLAC::File.open('test/data/flac.flac', false) do |f|
          f.picture_list.each do |_p|
            c += 1
          end
        end
      end
      assert_equal N, c
    end

    should 'process a flac file without picture data' do
      c = 0
      N.times do
        TagLib::FLAC::File.open('test/data/flac_nopic.flac', false) do |f|
          f.picture_list.each do |_p|
            c += 1
          end
        end
      end
      assert_equal 0, c
    end

    teardown do
    end
  end
end
