import 'package:music_metadata/music_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final parser = loadFromFile("file");
    final metadata = parser.parse();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(metadata.title, isNull);
    });
  });
}
