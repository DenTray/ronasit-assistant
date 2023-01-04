import './base_statistic_event.dart';

class SetRemainModeEvent extends BaseStatisticEvent {
  bool remainMode;

  SetRemainModeEvent(this.remainMode);
}