import 'package:mobile/W10-PRACTICE-Firebase-PART-2/model/comment/comment.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/model/songs/song.dart';

import '../../../model/artist/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<Artist?> fetchArtistById(String id);

  Future<List<Song>> fetchSongsByArtist(String artistId);

  Future<List<Comment>> fetchCommentsByArtist(String artistId);

  Future<Comment> postComment(Comment comment);
}
