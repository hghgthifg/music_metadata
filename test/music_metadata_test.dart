import 'package:music_metadata/music_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test: Id3v1 tags in mp3 file', () {
      final parser = loadFromFile("test/sample/Piano Magic Motive.mp3");
      final metadata = parser.parse();
      expect(metadata.title, "Piano Magic Motive");
      expect(metadata.artist, "Kevin MacLeod");
      expect(metadata.album, "Royalty Free");
      expect(metadata.comment, "Test Case 1");
      expect(metadata.track, 1);
      expect(metadata.genre![0], "Electronic");
    });
  });
}
