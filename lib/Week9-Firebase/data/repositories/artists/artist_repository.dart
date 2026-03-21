import 'package:mobile/Week9-Firebase/model/artists/artists.dart';

abstract class ArtistRepository {
  Future<List<Artists>> fetchArtists();

  Future<Artists?> fetchArtistById(String id);
}
