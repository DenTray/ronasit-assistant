import './base_settings_event.dart';

class UpdateRateCurrencyEvent extends BaseSettingsEvent {
  late int index;

  UpdateRateCurrencyEvent(this.index);
}