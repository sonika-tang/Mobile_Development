import 'package:mobile/Week9-Firebase/model/artists/artists.dart';
import 'package:mobile/Week9-Firebase/model/songs/song.dart';

class RichSong {
  final Song song;
  final Artists artist;

  const RichSong({required this.song, required this.artist});

  // Convenience pass-throughs so the UI can read directly
  String get id => song.id;
  String get title => song.title;
  Duration get duration => song.duration;
  Uri get imageUrl => song.imageUrl;
  String get artistName => artist.name;
  String get artistGenre => artist.genre;
  Uri get artistImageUrl => artist.imageUrl;
}
