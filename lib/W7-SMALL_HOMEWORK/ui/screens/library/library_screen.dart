import 'package:flutter/material.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/songs/song_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/library/view_model/library_view_model.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/library/widgets/library_content.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/player_state.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // inject the ViewModel, then return Content
    return ChangeNotifierProvider(
      create: (context) => LibraryViewModel(
        songRepository: context.read<SongRepository>(),
        playerState: context.read<PlayerState>(),
      ),
      child: const LibraryContent(),
    );
  }
}
