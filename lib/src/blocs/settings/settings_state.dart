import 'package:ronas_assistant/src/models/settings.dart';

class SettingsState {
  String locale = 'en';
  int workingDaysCount = 5;
  double rate = 1.0;
  String rateCurrency = 'Russian Ruble';

  Settings? settings;
  List<String> currenciesNames = [];

  SettingsState({ Settings? settings, List<String>? currenciesNames }) {
    if (settings != null) {
      locale = settings.language;
      workingDaysCount = settings.preferredWorkingDaysCount;
      rate = settings.rate;
    }

    if (currenciesNames != null) {
      this.currenciesNames = currenciesNames;

      if (settings != null) {
        rateCurrency = currenciesNames[settings.rateCurrencyIndex];
      }
    }
  }

  SettingsState copyWith({
    Settings? settings,
    List<String>? currenciesNames
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      currenciesNames: currenciesNames ?? this.currenciesNames
    );
  }
}