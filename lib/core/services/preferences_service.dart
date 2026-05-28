import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  late SharedPreferencesAsync _preferences;

  PreferencesService._internal();

  static PreferencesService instance = PreferencesService._internal();

  void init() {
    _preferences = SharedPreferencesAsync();
  }

  Future<void> setOnboardingScreen(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return await _preferences.getBool(key);
  }
}
