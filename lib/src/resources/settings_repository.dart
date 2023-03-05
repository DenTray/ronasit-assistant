import 'dart:async';
import '../models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static SettingsRepository? _instance;

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    return Settings(
      preferences.getInt('preferences.working_days_count') ?? 5,
      preferences.getString('preferences.locale') ?? 'en',
      preferences.getBool('preferences.is_remain_mode_enabled') ?? false,
      preferences.getDouble('preferences.rate') ?? 1.0,
      preferences.getString('preferences.rate_currency') ?? '\$',
      preferences.getInt('preferences.exchange_currency_symbol_index') ?? 0
    );
  }

  updateExchangeCurrency(int index) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setInt('preferences.exchange_currency_symbol_index', index);
  }

  updateRemainMode(bool isEnabled) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setBool('preferences.is_remain_mode_enabled', isEnabled);
  }

  updateWorkingDaysCount(int daysCount) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setInt('preferences.working_days_count', daysCount);
  }

  updateLocale(String locale) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setString('preferences.locale', locale);
  }

  updateRate(double rate) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setDouble('preferences.rate', rate);
  }

  updateRateCurrency(String currency) async {
    final preferences = await SharedPreferences.getInstance();

    preferences.setString('preferences.rate_currency', currency);
  }

  factory SettingsRepository.getInstance() => _instance ??= SettingsRepository._internal();

  SettingsRepository._internal();
}