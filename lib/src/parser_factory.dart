/// ParserFactory is a factory class to create specific parser instances.

import "dart:io";

import "id3v1/id3v1_parser.dart";
import "parser.dart";

String guessTypeFromExtension(String fileName) {
  switch (fileName.split(".").last) {
    case "mp3":
      return "id3v1";
    default:
      return "unknown";
  }
}

String getTagType(File file) {
  String type = guessTypeFromExtension(file.path);
  if (type == "unknown") {
    // TODO: implement a way to check if the file is a valid ID3v1 file
    return "unknown";
  }
  return type;
}

class ParserFactory {
  static Parser createParser(File file) {
    String type = getTagType(file);
    switch (type) {
      case "id3v1":
        return ID3v1Parser(file);
      default:
        throw "Unknown parser type: $type";
    }
  }
}
