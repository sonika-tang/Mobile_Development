import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  // List<Song>? _songs;

  // We hold one AsyncValue that capture all 3 possible state
  AsyncValue<List<Song>> _songState = const AsyncValue.loading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  // List<Song> get songs => _songs == null ? [] : _songs!;

  AsyncValue<List<Song>> get songState => _songState;

  // Getter that only have value when success
  List<Song> get songs => _songState.data ?? [];

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    // _songs = await songRepository.fetchSongs();
    _songState = const AsyncValue.loading();

    // 2 - notify listeners
    notifyListeners();

    try {
      final songs = await songRepository.fetchSongs();
      _songState = AsyncValue.success(songs);
    } catch (e) {
      _songState = AsyncValue.error(e.toString());
    }
    notifyListeners();
  }

  // UI can call this on error
  void retry() {
    _init();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}

/// Represents the 3 possible states of an async operation.
/// T is the type of data when successful
class AsyncValue<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  // Private constructor
  const AsyncValue._({this.data, this.error, this.isLoading = false});

  // 3 named constructors, one for each state:
  const AsyncValue.loading() : this._(isLoading: true);
  const AsyncValue.success(T data) : this._(data: data);
  const AsyncValue.error(String message) : this._(error: message);
}
