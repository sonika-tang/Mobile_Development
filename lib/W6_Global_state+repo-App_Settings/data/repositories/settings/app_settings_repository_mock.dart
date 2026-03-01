import '../../../model/settings/app_settings.dart';
import 'app_settings_repository.dart';

/// Mock implementation of AppSettingsRepository.
/// Defaults theme color is blue
class AppSettingsRepositoryMock implements AppSettingsRepository {
  AppSettings _settings = AppSettings(themeColor: ThemeColor.blue);

  @override
  Future<AppSettings> load() async {
    return _settings;
  }

  @override
  Future<void> save(AppSettings settings) async {
    _settings = settings;
  }
}
