import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/history/user_history_repository.dart';

class UserHistoryRepositoryMock implements UserHistoryRepository {
  final List<String> _history = ['101', '102']; 

  @override
  List<String> getRecentSongIds() => List.unmodifiable(_history);

  @override
  void addSongIds(String id) {
    _history.remove(id);
    _history.insert(0, id);
  }
}
