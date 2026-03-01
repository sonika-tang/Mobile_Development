import 'package:flutter/widgets.dart';

import '../../model/settings/app_settings.dart';
import '../../data/repositories/settings/app_settings_repository.dart';

class AppSettingsState extends ChangeNotifier {
  final AppSettingsRepository _repository;

  AppSettings? _appSettings;

  /// Inject the repository via constructor.
  AppSettingsState({required AppSettingsRepository repository})
      : _repository = repository;

  /// Load settings from repository.
  Future<void> init() async {
    // Might be used to load data from repository
    _appSettings = await _repository.load();
    notifyListeners();
  }

  ThemeColor get theme => _appSettings?.themeColor ?? ThemeColor.blue;

  Future<void> changeTheme(ThemeColor themeColor) async {
    _appSettings = (_appSettings ?? AppSettings(themeColor: ThemeColor.blue))
        .copyWith(themeColor: themeColor);

    // Persist to repository
    await _repository.save(_appSettings!);

    notifyListeners();
  }
}
