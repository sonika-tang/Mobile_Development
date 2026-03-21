import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/Week9-Firebase/data/dtos/artists_dto.dart';
import 'package:mobile/Week9-Firebase/data/repositories/artists/artist_repository.dart';
import 'package:mobile/Week9-Firebase/model/artists/artists.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static final Uri _artistsUrl = Uri.https(
    'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

  @override
  Future<List<Artists>> fetchArtists() async {
    final response = await http.get(_artistsUrl);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch artists. Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

    return json.entries
        .map(
          (entry) => ArtistsDto.fromJson(
            entry.key,
            entry.value as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<Artists?> fetchArtistById(String id) async {
    final url = Uri.https(
      'week-8-practice-e27cc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/artists/$id.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null) return null;
      return ArtistsDto.fromJson(id, body as Map<String, dynamic>);
    }

    throw Exception(
      'Failed to fetch artist $id. Status: ${response.statusCode}',
    );
  }
}
