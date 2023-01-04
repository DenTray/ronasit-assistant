import './base_settings_event.dart';

class UpdateLocaleEvent extends BaseSettingsEvent {
  late String locale;

  UpdateLocaleEvent(this.locale);
}