import './base_settings_event.dart';

class UpdateWorkingDaysCountEvent extends BaseSettingsEvent {
  late int count;

  UpdateWorkingDaysCountEvent(this.count);
}