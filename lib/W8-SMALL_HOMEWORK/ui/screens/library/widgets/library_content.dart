import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    LibraryViewModel mv = context.watch<LibraryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: listbuild(mv)),
        ],
      ),
    );
  }
}

Widget listbuild(LibraryViewModel vm) {
  final state = vm.songState;

  // Loading
  if (state.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  // Error
  if (state.error != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.error!,
            textAlign: TextAlign.center,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: vm.retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  // Success
  return ListView.builder(
    itemCount: vm.songs.length,
    itemBuilder: (context, index) => SongTile(
      song: vm.songs[index],
      isPlaying: vm.isSongPlaying(vm.songs[index]),
      onTap: () => vm.start(vm.songs[index]),
    ),
  );
}
