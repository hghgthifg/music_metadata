import "dart:io";

import "../metadata.dart";
import "../parser.dart";

extension StringTagEditExtensions on String {
  String trimTag() {
    return replaceAll(new RegExp(r'\0+$'), '');
  }
}

class ID3v1Parser extends Parser {
  File originalFile;

  ID3v1Parser(this.originalFile);

  @override
  Metadata parse() {
    var metadata = Metadata();

    var length = originalFile.lengthSync();

    // get the last 128 bytes of the file
    var buffer = originalFile.readAsBytesSync().sublist(length - 128, length);

    // check if the file has an ID3v1 tag
    var tag = String.fromCharCodes(buffer.sublist(0, 3));
    if (tag != "TAG") {
      print(tag);
      throw "Not an ID3v1 tag";
    }

    // get the title
    var title = String.fromCharCodes(buffer.sublist(3, 33));
    metadata.title = title.trimTag();

    // get the artist
    var artist = String.fromCharCodes(buffer.sublist(33, 63));
    metadata.artist = artist.trimTag();

    // get the album
    var album = String.fromCharCodes(buffer.sublist(63, 93));
    metadata.album = album.trimTag();

    var year = String.fromCharCodes(buffer.sublist(93, 97));
    metadata.year = int.tryParse(year.trimTag());

    var comment = String.fromCharCodes(buffer.sublist(97, 127));
    metadata.comment = comment.trimTag();

    // get the track number
    var track = buffer[126];
    metadata.track = track;

    // get the genre
    // TODO implement genre parsing

    return metadata;
  }
}
