import 'package:flutter/material.dart';
import 'package:mobile/W6_Global_state+repo-App_Settings/ui/theme/theme.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/model/songs/song.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/library/view_model/library_view_model.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/settings_state.dart';
import 'package:provider/provider.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LibraryViewModel>();
    final settingState = context.read<AppSettingsState>();

    return Container(
      color: settingState.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('Library', style: AppTextStyles.heading),
          const SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: vm.songs.length,
              itemBuilder: (context, index) {
                final song = vm.songs[index];
                return SongTile(
                  song: song,
                  isPlaying: vm.isPlaying(song),
                  onTap: () => vm.play(song),
                  onStop: () => vm.stop,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.onStop,
  });

  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(song.title),
      trailing: isPlaying
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Playing', style: TextStyle(color: Colors.amber)),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: onStop, child: Text('Stop')),
              ],
            )
          : null,
    );
  }
}
