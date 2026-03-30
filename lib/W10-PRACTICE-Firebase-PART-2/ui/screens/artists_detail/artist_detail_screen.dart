import 'package:flutter/material.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/ui/screens/artists_detail/view_model/artists_detail_view_model.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/ui/screens/artists_detail/widgets/comment_tail.dart';
import 'package:mobile/W10-PRACTICE-Firebase-PART-2/ui/widgets/song/song_tile.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/artist/artist_repository.dart';
import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import '../../../ui/utils/async_value.dart';
import 'widgets/comment_form.dart';

class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        artist: artist,
      ),
      child: _ArtistDetailContent(artist: artist),
    );
  }
}

class _ArtistDetailContent extends StatelessWidget {
  const _ArtistDetailContent({required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    final ArtistDetailViewModel vm = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(artist.name), centerTitle: true),
      bottomNavigationBar: CommentForm(
        isLoading: vm.isPostingComment,
        onSubmit: (text) => vm.addComment(text),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(artist.imageUrl.toString()),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              artist.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              artist.genre,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Songs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildSongsSection(vm.songsValue),

          const SizedBox(height: 24),

          const Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildCommentsSection(vm.commentsValue),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSongsSection(AsyncValue<List<Song>> songsValue) {
    switch (songsValue.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());

      case AsyncValueState.error:
        return Text(
          'Error loading songs: ${songsValue.error}',
          style: const TextStyle(color: Colors.red),
        );

      case AsyncValueState.success:
        final songs = songsValue.data!;
        if (songs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('No songs for this artist yet.')),
          );
        }
        return Column(
          children: songs.map((song) => SongTile(song: song)).toList(),
        );
    }
  }

  Widget _buildCommentsSection(AsyncValue<List<Comment>> commentsValue) {
    switch (commentsValue.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());

      case AsyncValueState.error:
        return Text(
          'Error loading comments: ${commentsValue.error}',
          style: const TextStyle(color: Colors.red),
        );

      case AsyncValueState.success:
        final comments = commentsValue.data!;
        if (comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('No comments yet. Be the first!')),
          );
        }
        return Column(
          children: comments
              .map((comment) => CommentTile(comment: comment))
              .toList(),
        );
    }
  }
}
