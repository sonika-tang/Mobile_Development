import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/data/dtos/comment_dto.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/data/dtos/song_dto.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/model/comment/comment.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/model/songs/song.dart';

import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  // static final Uri artistsUrl = Uri.https(
  //   'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
  //   '/artists.json',
  // );

  static final Uri baseUri = Uri.https(
    'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static final Uri artistUrl = baseUri.replace(path: '/artists.json');

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
    final http.Response response = await http.get(artistUrl);

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
    // final url = Uri.https(
    //   'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    //   '/artists/$id.json',
    // );

    final Uri url = baseUri.replace(path: '/artists/$id.json');

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

  @override
  Future<List<Comment>> fetchCommentsByArtist(String artistId) async {
    final Uri uri = baseUri.replace(
      path: '/comments.json',
      queryParameters: {'orderBy': '"artistId"', 'equalTo': '"$artistId"'},
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null) return [];

      final Map<String, dynamic> json = body;
      return [
        for (final entry in json.entries)
          CommentDto.fromJson(entry.key, entry.value),
      ];
    }

    throw Exception(
      'Fail to load comment for artist $artistId (Status:${response.statusCode})',
    );
  }

  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    final Uri uri = baseUri.replace(
      path: '/songs.json',
      queryParameters: {'orderBy': '"artistId"', 'equalTo': '"$artistId"'},
    );

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return [
        for (final entry in json.entries)
          SongDto.fromJson(entry.key, entry.value),
      ];
    }

    throw Exception(
      'Fail to load songs from artist $artistId (Status: ${response.statusCode})',
    );
  }

  @override
  Future<Comment> postComment(Comment comment) async {
    final Uri uri = baseUri.replace(path: '/comments.json');

    final commentDto = CommentDto();
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(commentDto.toJson(comment)),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final String generateId = json['name'];

      return Comment(
        id: generateId,
        artistId: comment.artistId,
        text: comment.text,
        createdAt: comment.createdAt,
      );
    }
    throw Exception('Fail to post comment (Status: ${response.statusCode})');
  }
}
