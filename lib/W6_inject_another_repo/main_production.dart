import 'package:mobile/W6_inject_another_repo/data/repositories/songs/song_repository_remote.dart';
import 'package:provider/provider.dart';

import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';

List<Provider> get providersProduction {
  return [
    Provider<SongRepository>(create: (context) => SongRepositoryRemote()),
  ];
}

void main() {
  mainCommon(providersProduction);
}
