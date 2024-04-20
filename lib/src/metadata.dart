/// Here is the definition of some classes, which represents the metadata of a track.

import 'dart:core';
import 'dart:typed_data';

class CoverImage {
  String? mime;
  Uint8List? data;
  String? description;
  String? type;
  String? name;
}

class Metadata {
  // TODO: support more types

  /// Release year
  int? year;

  /// Track title
  String? title;

  /// Track artist, maybe several artists written in a single String
  String? artist;

  /// Track album artists
  String? albumartists;

  /// Album title
  String? album;

  /// Date
  String? date;

  /// Genre
  List<String>? genre;

  // Cover
  CoverImage? cover;

  // Comment
  String? comment;

  // The number of the track in the album
  int? track;
}
