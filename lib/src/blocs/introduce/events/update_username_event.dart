import 'package:ronas_assistant/src/blocs/introduce/events/base_introduce_event.dart';

class UpdateUsernameEvent extends BaseIntroduceEvent {
  String value;

  UpdateUsernameEvent(this.value);
}