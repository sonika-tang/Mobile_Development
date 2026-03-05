import 'package:flutter/material.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/history/user_history_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/songs/song_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/home/view_model/home_view_model.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/screens/home/widgets/home_content.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/ui/states/player_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        songRepository: context.read<SongRepository>(),
        playerState: context.read<PlayerState>(), 
        historyRepository: context.read<UserHistoryRepository>(),
      ),
      child: const HomeContent(),
    );
  }
}