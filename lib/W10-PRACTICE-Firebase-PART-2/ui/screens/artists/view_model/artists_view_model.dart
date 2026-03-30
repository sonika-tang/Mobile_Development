import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../utils/async_value.dart';

class ArtistsViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;

  AsyncValue<List<Artist>> artistsValue = AsyncValue.loading();

  ArtistsViewModel({required this.artistRepository}) {
    _init();
  }

  void _init() async {
    fetchArtists();
  }

  Future<void> fetchArtists({bool forceFetch = false}) async {
    artistsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final List<Artist> artists = await artistRepository.fetchArtists(
        forceFetch: forceFetch,
      );
      artistsValue = AsyncValue.success(artists);
    } catch (e) {
      artistsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }
}
