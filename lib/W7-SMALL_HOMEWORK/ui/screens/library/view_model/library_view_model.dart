import 'package:flutter/material.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/songs/song_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/model/songs/song.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/player_state.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final PlayerState _playerState;

  List<Song> _songs = [];

  LibraryViewModel({
    required SongRepository songRepository,
    required PlayerState playerState,
  }) : _songRepository = songRepository,
       _playerState = playerState {
    // Listen to PlayerState (when it changes, notify our listeners)
    _playerState.addListener(_onPlayerStateChanged);
    init();
  }

  void _onPlayerStateChanged() {
    notifyListeners();
  }

  void init() {
    _songs = _songRepository.fetchSongs();
    notifyListeners();
  }

  // Getter
  List<Song> get songs => _songs;

  bool isPlaying(Song song) => _playerState.currentSong == song;

  Song? get currentSong => _playerState.currentSong;

  // Action
  void play(Song song) => _playerState.start(song);

  void stop() => _playerState.stop();

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}
