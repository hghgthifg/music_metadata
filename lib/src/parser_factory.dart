/// ParserFactory is a factory class to create specific parser instances.

import "dart:io";

import "id3v1/id3v1_parser.dart";
import "parser.dart";

class ParserFactory {
  static Parser createParser(String type, File file) {
    switch (type) {
      case "id3v1":
        return ID3v1Parser(file);
      default:
        throw "Unknown parser type: $type";
    }
  }
}
