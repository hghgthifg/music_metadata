import 'dart:io';

import 'package:music_metadata/music_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test: read and write Id3v1 tags in mp3 file', () {
      final music_file = "test/sample/Piano Magic Motive.mp3";
      final new_music_file = "test/sample/Piano Magic Motive - new.mp3";

      // Read test
      final parser = loadFromFile(music_file);
      final metadata = parser.read();
      expect(metadata.title, "Piano Magic Motive");
      expect(metadata.artist, "Kevin MacLeod");
      expect(metadata.album, "Royalty Free");
      expect(metadata.comment, "Test Case 1");
      expect(metadata.track, 1);
      expect(metadata.genre![0], "Electronic");

      // Write test
      File(music_file).copy(new_music_file);
      final parser2 = loadFromFile(new_music_file);
      parser2.write(metadata);

      final parser3 = loadFromFile(new_music_file);
      final metadataModified = parser3.read();
      expect(metadataModified.title, "Piano Magic Motive");
      expect(metadataModified.artist, "Kevin MacLeod");
      expect(metadataModified.album, "Royalty Free");
      expect(metadataModified.comment, "Test Case 1");
      expect(metadataModified.track, 1);
      expect(metadataModified.genre![0], "Electronic");

      File(new_music_file).delete();
    });
  });
}
