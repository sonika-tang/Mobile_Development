import 'package:mobile/W6_inject_another_repo/data/repositories/songs/song_repository_mock.dart';
import 'package:provider/provider.dart';


import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';

/// Configure provider dependencies for dev environement
List<Provider> get providersLocal {
  return [Provider<SongRepository>(create: (context) => SongRepositoryMock())];
}

void main() {
  mainCommon(providersLocal);
}
