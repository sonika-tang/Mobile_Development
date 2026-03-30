import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  bool isPostingComment = false;

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() => fetchData();

  Future<void> fetchData() async {
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    await Future.wait([fetchSongs(), fetchComments()]);

    notifyListeners();
  }

  Future<void> fetchSongs() async {
    try {
      final songs = await artistRepository.fetchSongsByArtist(artist.id);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
  }

  Future<void> fetchComments() async {
    try {
      final comments = await artistRepository.fetchCommentsByArtist(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;

    isPostingComment = true;
    notifyListeners();

    try {
      final newComment = Comment(
        id: '',
        artistId: artist.id,
        text: text.trim(),
        createdAt: DateTime.now(),
      );

      final savedComment = await artistRepository.postComment(newComment);

      final currentComments = commentsValue.data ?? [];
      commentsValue = AsyncValue.success([savedComment, ...currentComments]);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }

    isPostingComment = false;
    notifyListeners();
  }
}
