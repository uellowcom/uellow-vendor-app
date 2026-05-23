import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConstants.themeKey);
    state = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    });
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(AppConstants.langKey) ?? 'en';
    state = Locale(lang);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.langKey, locale.languageCode);
  }

  bool get isArabic => state.languageCode == 'ar';
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
