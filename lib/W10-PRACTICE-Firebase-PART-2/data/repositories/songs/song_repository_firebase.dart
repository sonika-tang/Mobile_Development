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

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSongs != null) {
      return _cachedSongs!;
    }

    final songs = await fetchSongsAPI();
    _cachedSongs = songs;
    return songs;
  }

  Future<List<Song>> fetchSongsAPI() async {
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
  Future<Song?> fetchSongById(String id) async {
    final songId = baseUri.replace(path: '/songs/$id.json');

    final response = await http.get(songId);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null) return null;
      return SongDto.fromJson(id, body);
    }

    throw Exception('Failed to fetch song $id. Status: ${response.statusCode}');
  }

  @override
  Future<void> likeSong(String songId, int currentLikes) async {
    final uri = baseUri.replace(path: '/songs/$songId.json');

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({SongDto.likesKey: currentLikes + 1}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to like song $songId (status ${response.statusCode})',
      );
    }

    // Update cache if present
    if (_cachedSongs != null) {
      _cachedSongs = [
        for (final song in _cachedSongs!)
          song.id == songId ? song.copyWith(likes: currentLikes + 1) : song,
      ];
    }
  }
}
