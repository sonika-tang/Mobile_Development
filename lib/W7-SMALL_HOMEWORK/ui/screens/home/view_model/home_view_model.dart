import 'package:flutter/widgets.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/history/user_history_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/songs/song_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/model/songs/song.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/player_state.dart';

class HomeViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final UserHistoryRepository _historyRepository;
  final PlayerState _playerState;

  List<Song> _recentSongs = [];
  List<Song> _recommendedSongs = [];

  HomeViewModel({
    required SongRepository songRepository,
    required UserHistoryRepository historyRepository,
    required PlayerState playerState,
  }) : _songRepository = songRepository,
       _historyRepository = historyRepository,
       _playerState = playerState {
    _playerState.addListener(_onPlayerStateChanged);
    init();
  }

  void _onPlayerStateChanged() {
    notifyListeners();
  }

  void init() {
    final allSongs = _songRepository.fetchSongs();
    final recentIds = _historyRepository.getRecentSongIds();

    // Convert IDs to full Song objects
_recentSongs = recentIds
        .map((id) => _songRepository.fetchSongById(id))
        .whereType<Song>()
        .toList();

    // Recommended songs
    final recentIdSet = recentIds.toSet();
    _recommendedSongs = allSongs
        .where((song) => !recentIdSet.contains(song.id))
        .toList();

    notifyListeners();
  }

  // Getter
  List<Song> get recentSongs => _recentSongs;
  List<Song> get recommendedSongs => _recommendedSongs;
  bool isPlaying(Song song) => _playerState.currentSong == song;

  // Action
  void play(Song song) {
    _historyRepository.addSongIds(song.id); // update history
    _playerState.start(song);
    init(); // refresh lists
  }

  void stop() => _playerState.stop();

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}
