import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  bool _hasPreferences = false;
  String _language = 'English';
  String _currency = 'USD';

  bool get hasPreferences => _hasPreferences;
  String get language => _language;
  String get currency => _currency;

  Future<void> setPreferences(String language, String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    await prefs.setString('currency', currency);
    await prefs.setBool('hasPreferences', true);

    _language = language;
    _currency = currency;
    _hasPreferences = true;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _hasPreferences = prefs.getBool('hasPreferences') ?? false;
    _language = prefs.getString('language') ?? 'English';
    _currency = prefs.getString('currency') ?? 'USD';
    notifyListeners();
  }
}
