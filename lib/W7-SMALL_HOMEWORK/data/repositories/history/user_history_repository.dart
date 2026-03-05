abstract class UserHistoryRepository {
  List<String> getRecentSongIds();
  void addSongIds(String id);
}
