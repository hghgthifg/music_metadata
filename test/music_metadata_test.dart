import 'package:music_metadata/music_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      final parser = loadFromFile("test/sample/Piano Magic Motive.mp3");
      final metadata = parser.parse();

      print(metadata.title);

      expect(metadata.title, "Piano Magic Motive");
    });
  });
}
