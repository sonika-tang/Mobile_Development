import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static final Uri baseUri = Uri.https(
    'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static final Uri songUrl = baseUri.replace(path: '/songs.json');
  static final Uri artistUrl = baseUri.replace(path: '/artists.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songUrl);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      List<Song> result = [];

      for (var iteration in songJson.entries) {
        result.add(SongDto.fromJson(iteration.key, iteration.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
}
