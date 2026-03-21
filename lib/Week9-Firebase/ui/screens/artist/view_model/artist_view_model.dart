import 'package:flutter/material.dart';
import 'package:mobile/Week9-Firebase/data/repositories/artists/artist_repository.dart';
import 'package:mobile/Week9-Firebase/model/artists/artists.dart';
import 'package:mobile/Week9-Firebase/ui/utils/async_value.dart';

class ArtistViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;

  AsyncValue<List<Artists>> artistValue = AsyncValue.loading();

  ArtistViewModel({required this.artistRepository}) {
    _init();
  }

  void _init() async {
    fetchArtists();
  }

  void fetchArtists() async {
    artistValue = AsyncValue.loading();
    notifyListeners();

    try {
      final artists = await artistRepository.fetchArtists();
      artistValue = AsyncValue.success(artists);
    } catch (e) {
      artistValue = AsyncValue.error(e);
    }
    notifyListeners();
  }
}
