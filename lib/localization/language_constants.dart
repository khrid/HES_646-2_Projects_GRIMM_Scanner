
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localization.dart';

const String LANGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String GERMAN = 'de';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? "fr";
  return locale(languageCode);
}

Future<String> getLocaleCode() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString(LANGUAGE_CODE) ?? "fr";
}

Locale locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'US');
    case FRENCH:
      return const Locale(FRENCH, "FR");
      case GERMAN:
      return const Locale(GERMAN, "DE");
    default:
      return const Locale(FRENCH, "FR");
  }
}

String? getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context)!.translate(key);
}
