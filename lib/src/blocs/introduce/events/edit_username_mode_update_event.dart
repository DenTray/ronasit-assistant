import 'package:ronas_assistant/src/blocs/introduce/events/base_introduce_event.dart';

class EditUsernameModeUpdate extends BaseIntroduceEvent {
  bool value;

  EditUsernameModeUpdate(this.value);
}