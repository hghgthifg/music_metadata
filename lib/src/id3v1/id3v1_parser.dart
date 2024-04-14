import "dart:io";

import "../metadata.dart";
import "../parser.dart";

class ID3v1Parser extends Parser {
  ID3v1Parser(File file);

  @override
  Metadata parse() {
    return Metadata();
    // TODO: implement parse
  }
}
