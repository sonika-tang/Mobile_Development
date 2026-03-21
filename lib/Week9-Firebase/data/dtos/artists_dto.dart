import 'package:mobile/Week9-Firebase/model/artists/artists.dart';

class ArtistsDto {
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageUrlKey = 'imageUrl';

  static Artists fromJson(String id, Map<String, dynamic> json) {
    assert(json[nameKey] is String);
    assert(json[genreKey] is String);
    assert(json[imageUrlKey] is String);

    return Artists(
      id: id,
      genre: json[genreKey],
      imageUrl: Uri.parse(json[imageUrlKey]),
      name: json[nameKey],
    );
  }

  Map<String, dynamic> toJson(Artists artist) {
    return {
      genreKey: artist.genre,
      imageUrlKey: artist.imageUrl,
      nameKey: artist.name,
    };
  }
}
