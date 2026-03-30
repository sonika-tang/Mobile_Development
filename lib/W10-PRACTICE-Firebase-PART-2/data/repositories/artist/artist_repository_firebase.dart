import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static final Uri artistsUrl = Uri.https(
    'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final artists = await fetchArtistAPI();
    _cachedArtists = artists;
    return artists;
  }

  Future<List<Artist>> fetchArtistAPI() async {
    final http.Response response = await http.get(artistsUrl);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final url = Uri.https(
      'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artists/$id.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null) return null;
      return ArtistDto.fromJson(id, body as Map<String, dynamic>);
    }

    throw Exception(
      'Failed to fetch artist $id. Status: ${response.statusCode}',
    );
  }
}
