import 'package:ronas_assistant/src/blocs/introduce/events/base_introduce_event.dart';

class UpdateFirstNameEvent extends BaseIntroduceEvent {
  String value;

  UpdateFirstNameEvent(this.value);
}