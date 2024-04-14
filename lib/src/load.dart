import "dart:io";

import "./parser.dart";
import "./parser_factory.dart";

String getMetaType(File file) {
  return "id3v1";
}

Parser loadFromFile(String path) {
  try {
    var file = File(path);
    var type = getMetaType(file);
    switch (type) {
      case "id3v1":
        return ParserFactory.createParser(type, file);
      default:
        throw "Unsupported metadata type $type";
    }
  } catch (error) {
    rethrow;
  }
}
