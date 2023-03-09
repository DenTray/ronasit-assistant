import 'package:ronas_assistant/src/models/settings.dart';

class SettingsState {
  late String locale;
  late int workingDaysCount;
  late double rate;
  late String rateCurrency;

  late Settings settings;

  SettingsState({ Settings? settings }) {
    locale = settings?.language ?? 'en';
    workingDaysCount = settings?.preferredWorkingDaysCount ?? 5;
    rate = settings?.rate ?? 1.0;
    rateCurrency = settings?.rateCurrency ?? '\$';
  }

  SettingsState copyWith({
    Settings? settings,
  }) {
    return SettingsState(
      settings: settings ?? this.settings
    );
  }
}