import "dart:io";
import "dart:typed_data";

import "../metadata.dart";
import "../parser.dart";

extension StringTagEditExtensions on String {
  String? trimTag() {
    return replaceAll(RegExp(r'\0+$'), '');
  }
}

class ID3v1Parser extends Parser {
  File originalFile;

  ID3v1Parser(this.originalFile);

  @override
  Metadata read() {
    var metadata = Metadata();

    if (!originalFile.existsSync()) {
      throw "File does not exist";
    }

    var length = originalFile.lengthSync();

    // Get the last 128 bytes of the file
    var buffer = originalFile.readAsBytesSync().sublist(length - 128, length);

    // check if the file has an ID3v1 tag
    var tag = String.fromCharCodes(buffer.sublist(0, 3));
    if (tag != "TAG") {
      throw "Not an ID3v1 tag";
    }

    // Get the title
    var title = String.fromCharCodes(buffer.sublist(3, 33));
    metadata.title = title.trimTag();

    // Get the artist
    var artist = String.fromCharCodes(buffer.sublist(33, 63));
    metadata.artist = artist.trimTag();

    // Get the album
    var album = String.fromCharCodes(buffer.sublist(63, 93));
    metadata.album = album.trimTag();

    // Get the year
    var year = String.fromCharCodes(buffer.sublist(93, 97));
    metadata.year =
        (year.trimTag() != null) ? int.tryParse(year.trimTag()!.trim()) : null;

    // Get the comment and the track number
    // If type is 0, it means the comment is 30 characters long
    // If type is 1, it means the comment is 28 characters long, and the track number is in the 126th byte
    String? comment;
    int? track;
    var type = buffer[125];
    if (type == 1) {
      comment = String.fromCharCodes(buffer.sublist(97, 127));
      track = null;
    } else if (type == 0) {
      comment = String.fromCharCodes(buffer.sublist(97, 125));
      track = buffer[126];
    }
    metadata.comment = comment?.trimTag();
    metadata.track = track;

    // Get the genre
    var genreCode = buffer[127];
    if (genreCode != 255) {
      metadata.genre = <String>[];
      metadata.genre?.add(genres[genreCode]);
    }

    this.metadata = metadata;

    return metadata;
  }

  @override
  void write(Metadata metadata) {
    var buffer = Uint8List(128);

    buffer.setRange(0, 3, Uint8List.fromList("TAG".codeUnits)); // TAG

    void setMetadataField(String? field, int start, int end) {
      field ??= '';
      // Ensure the string does not exceed the allocated buffer range
      String truncatedField =
          field.length > end - start ? field.substring(0, end - start) : field;

      truncatedField = truncatedField.padRight(end - start, '\u0000');

      // Convert to bytes and write to buffer
      buffer.setRange(start, end, Uint8List.fromList(truncatedField.codeUnits));
    }

    setMetadataField(metadata.title, 3, 33); // Title
    setMetadataField(metadata.artist, 33, 63); // Artist
    setMetadataField(metadata.album, 63, 93); // Album
    setMetadataField(metadata.year.toString(), 93, 97); // Year
    // Note: If the comment is longer than 28 characters and the track number exists, it will be cut into 28 characters.
    setMetadataField(metadata.comment, 97, 127); // Comment

    if (metadata.track != null) {
      buffer[125] = 0; // type 1
      buffer[126] = metadata.track!; // track number
    } else {
      buffer[125] = 1; // type 0
    }

    int genreIndex = genres.indexOf(metadata.genre?[0] ?? '');
    buffer[127] = genreIndex >= 0 && genreIndex < 128 ? genreIndex : 255;

    // Check if "TAG" exists at the end of the file; if not, write the entire tag
    var length = originalFile.lengthSync();
    var lastBytes =
        originalFile.readAsBytesSync().sublist(length - 128, length);
    var tag = String.fromCharCodes(lastBytes.sublist(0, 3));
    if (tag != "TAG") {
      originalFile.writeAsBytesSync(buffer);
      return;
    } else {
      originalFile.writeAsBytesSync(
          originalFile.readAsBytesSync().sublist(0, length - 128) + buffer);
    }

    return;
  }

  static const genres = [
    'Blues',
    'Classic Rock',
    'Country',
    'Dance',
    'Disco',
    'Funk',
    'Grunge',
    'Hip-Hop',
    'Jazz',
    'Metal',
    'New Age',
    'Oldies',
    'Other',
    'Pop',
    'R&B',
    'Rap',
    'Reggae',
    'Rock',
    'Techno',
    'Industrial',
    'Alternative',
    'Ska',
    'Death Metal',
    'Pranks',
    'Soundtrack',
    'Euro-Techno',
    'Ambient',
    'Trip-Hop',
    'Vocal',
    'Jazz+Funk',
    'Fusion',
    'Trance',
    'Classical',
    'Instrumental',
    'Acid',
    'House',
    'Game',
    'Sound Clip',
    'Gospel',
    'Noise',
    'Alt. Rock',
    'Bass',
    'Soul',
    'Punk',
    'Space',
    'Meditative',
    'Instrumental Pop',
    'Instrumental Rock',
    'Ethnic',
    'Gothic',
    'Darkwave',
    'Techno-Industrial',
    'Electronic',
    'Pop-Folk',
    'Eurodance',
    'Dream',
    'Southern Rock',
    'Comedy',
    'Cult',
    'Gangsta Rap',
    'Top 40',
    'Christian Rap',
    'Pop/Funk',
    'Jungle',
    'Native American',
    'Cabaret',
    'New Wave',
    'Psychedelic',
    'Rave',
    'Showtunes',
    'Trailer',
    'Lo-Fi',
    'Tribal',
    'Acid Punk',
    'Acid Jazz',
    'Polka',
    'Retro',
    'Musical',
    'Rock & Roll',
    'Hard Rock',
    'Folk',
    'Folk/Rock',
    'National Folk',
    'Swing',
    'Fast-Fusion',
    'Bebob',
    'Latin',
    'Revival',
    'Celtic',
    'Bluegrass',
    'Avantgarde',
    'Gothic Rock',
    'Progressive Rock',
    'Psychedelic Rock',
    'Symphonic Rock',
    'Slow Rock',
    'Big Band',
    'Chorus',
    'Easy Listening',
    'Acoustic',
    'Humour',
    'Speech',
    'Chanson',
    'Opera',
    'Chamber Music',
    'Sonata',
    'Symphony',
    'Booty Bass',
    'Primus',
    'Porn Groove',
    'Satire',
    'Slow Jam',
    'Club',
    'Tango',
    'Samba',
    'Folklore',
    'Ballad',
    'Power Ballad',
    'Rhythmic Soul',
    'Freestyle',
    'Duet',
    'Punk Rock',
    'Drum Solo',
    'A Cappella',
    'Euro-House',
    'Dance Hall',
    'Goa',
    'Drum & Bass',
    'Club-House',
    'Hardcore',
    'Terror',
    'Indie',
    'BritPop',
    'Negerpunk',
    'Polsk Punk',
    'Beat',
    'Christian Gangsta Rap',
    'Heavy Metal',
    'Black Metal',
    'Crossover',
    'Contemporary Christian',
    'Christian Rock',
    'Merengue',
    'Salsa',
    'Thrash Metal',
    'Anime',
    'JPop',
    'Synthpop',
    'Abstract',
    'Art Rock',
    'Baroque',
    'Bhangra',
    'Big Beat',
    'Breakbeat',
    'Chillout',
    'Downtempo',
    'Dub',
    'EBM',
    'Eclectic',
    'Electro',
    'Electroclash',
    'Emo',
    'Experimental',
    'Garage',
    'Global',
    'IDM',
    'Illbient',
    'Industro-Goth',
    'Jam Band',
    'Krautrock',
    'Leftfield',
    'Lounge',
    'Math Rock',
    'New Romantic',
    'Nu-Breakz',
    'Post-Punk',
    'Post-Rock',
    'Psytrance',
    'Shoegaze',
    'Space Rock',
    'Trop Rock',
    'World Music',
    'Neoclassical',
    'Audiobook',
    'Audio Theatre',
    'Neue Deutsche Welle',
    'Podcast',
    'Indie Rock',
    'G-Funk',
    'Dubstep',
    'Garage Rock',
    'Psybient'
  ];
}
