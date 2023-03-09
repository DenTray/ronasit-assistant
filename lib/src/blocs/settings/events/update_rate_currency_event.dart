import './base_settings_event.dart';

class UpdateRateCurrencyEvent extends BaseSettingsEvent {
  late String value;

  UpdateRateCurrencyEvent(this.value);
}