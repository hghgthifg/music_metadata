import "dart:io";

import "./parser.dart";
import "./parser_factory.dart";

Parser loadFromFile(String path) {
  try {
    var file = File(path);
    return ParserFactory.createParser(file);
  } catch (error) {
    rethrow;
  }
}
