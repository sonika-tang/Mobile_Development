import 'package:flutter/material.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/home/view_model/home_view_model.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/library/widgets/library_content.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/settings_state.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final settings = context.read<AppSettingsState>();

    return Container(
      color: settings.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Home", style: AppTextStyles.heading)),
          Text("Your recent songs", style: AppTextStyles.label),
          ...vm.recentSongs.map(
            (song) => SongTile(
              song: song,
              isPlaying: vm.isPlaying(song),
              onTap: () => vm.play(song),
              onStop: () => vm.stop(),
            ),
          ),
          Text("You might also like", style: AppTextStyles.label),
          ...vm.recommendedSongs.map(
            (song) => SongTile(
              song: song,
              isPlaying: vm.isPlaying(song),
              onTap: () => vm.play(song),
              onStop: () => vm.stop(),
            ),
          ),
        ],
      ),
    );
  }
}
