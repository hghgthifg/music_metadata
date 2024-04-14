/// Parser is the tool to operate on metadata, such as reading and writing.

import "./metadata.dart";

abstract class Parser {
  late Metadata metadata;

  void init(Metadata metadata) {
    this.metadata = metadata;
  }

  Metadata parse();
}
