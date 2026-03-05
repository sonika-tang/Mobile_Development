import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/history/user_history_repository.dart';
import 'package:mobile/W7-SMALL_HOMEWORK/data/repositories/history/user_history_repository_mock.dart';
import 'package:provider/provider.dart';
import 'package:nested/nested.dart';

import 'main_common.dart';
import 'data/repositories/settings/app_settings_repository_mock.dart';
import 'data/repositories/songs/song_repository.dart';
import 'data/repositories/songs/song_repository_mock.dart';
import 'ui/states/player_state.dart';
import 'ui/states/settings_state.dart';

/// Configure provider dependencies for dev environment
List<SingleChildWidget> get devProviders {
  final appSettingsRepository = AppSettingsRepositoryMock();

  return [
    // 1 - Inject the song repository
    Provider<SongRepository>(create: (_) => SongRepositoryMock()),

    // 2 - Inject the player state
    ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),

    // 3 - Inject the  app setting state
    ChangeNotifierProvider<AppSettingsState>(
      create: (_) => AppSettingsState(repository: appSettingsRepository),
    ),

    // 4 - Inject the app UserHistoryRepository
    Provider<UserHistoryRepository>(create: (_) => UserHistoryRepositoryMock()),
  ];
}

void main() {
  mainCommon(devProviders);
}
