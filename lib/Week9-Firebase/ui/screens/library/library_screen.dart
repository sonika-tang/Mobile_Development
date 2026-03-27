import 'package:flutter/material.dart';
import 'package:mobile/Week9-Firebase/data/repositories/artists/artist_repository.dart';
import 'package:provider/provider.dart';
import 'view_model/library_view_model.dart';
import '../../../data/repositories/songs/song_repository.dart';
import '../../states/player_state.dart';
import 'widgets/library_content.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryViewModel(
        songRepository: context.read<SongRepository>(),
        artistRepository: context.read<ArtistRepository>(),
        playerState: context.read<PlayerState>(),
      ),
      child: const LibraryContent(),
    );
  }
}
