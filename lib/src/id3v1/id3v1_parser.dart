import "dart:io";

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

    // get the year
    var year = String.fromCharCodes(buffer.sublist(93, 97));
    metadata.year =
        (year.trimTag() != null) ? int.tryParse(year.trimTag()!.trim()) : null;

    // get the comment and the track number
    // if type is 0, meaning the comment is 30 characters long
    // if type is 1, meaning the comment is 28 characters long, and the track number is in the 126th byte
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

    // get the genre
    var genreCode = buffer[127];
    if (genreCode != 255) {
      metadata.genre = <String>[];
      metadata.genre?.add(genres[genreCode]);
    }

    // TODO implement genre parsing

    return metadata;
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
