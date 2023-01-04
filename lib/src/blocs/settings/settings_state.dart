import 'package:ronas_assistant/src/models/settings.dart';

class SettingsState {
  late String locale;
  late int workingDaysCount;
  late double rate;

  SettingsState(Settings? settings) {
    locale = settings?.language ?? 'en';
    workingDaysCount = settings?.preferredWorkingDaysCount ?? 5;
    rate = settings?.rate ?? 1.0;
  }
}