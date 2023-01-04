import './base_settings_event.dart';

class UpdateRateEvent extends BaseSettingsEvent {
  late String? intPart;
  late String? decimalPart;

  UpdateRateEvent(this.intPart, this.decimalPart);
}