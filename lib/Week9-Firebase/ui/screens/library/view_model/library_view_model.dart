import 'package:flutter/material.dart';
import 'package:mobile/Week9-Firebase/data/repositories/artists/artist_repository.dart';
import 'package:mobile/Week9-Firebase/model/artists/artists.dart';
import 'package:mobile/Week9-Firebase/model/artists/rich_song.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<RichSong>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // // 1- Loading state
    // songsValue = AsyncValue.loading();
    // notifyListeners();

    // try {
    //   // 2- Fetch is successfull
    //   List<Song> songs = await songRepository.fetchSongs();
    //   songsValue = AsyncValue.success(songs);
    // } catch (e) {
    //   // 3- Fetch is unsucessfull
    //   songsValue = AsyncValue.error(e);
    // }
    //  notifyListeners();

    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // Fetch songs and artists together
      final songs = await songRepository.fetchSongs();
      final artists = await artistRepository.fetchArtists();

      // Build lookup map for artists
      final Map<String, Artists> artistById = {};
      for (final artist in artists) {
        artistById[artist.id] = artist;
      }

      // Map songs into RichSong objects
      final richSongs = songs
          .map((song) {
            final artist = artistById[song.artistId];
            if (artist == null) {
              print(
                'Warning: no artist found for song ${song.id} '
                '(artistId: ${song.artistId})',
              );
              return null; // skip if no artist
            }
            return RichSong(song: song, artist: artist);
          })
          .whereType<RichSong>()
          .toList();

      // Success state
      songsValue = AsyncValue.success(richSongs);
    } catch (e) {
      // Error state
      songsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  // bool isSongPlaying(Song song) => playerState.currentSong == song;

  // void start(Song song) => playerState.start(song);
  // void stop(Song song) => playerState.stop();

  bool isSongPlaying(RichSong richSong) => playerState.currentSong?.id == richSong.id;

  void start(RichSong richSong) => playerState.start(richSong.song);
  void stop(RichSong richSong) => playerState.stop();
}
