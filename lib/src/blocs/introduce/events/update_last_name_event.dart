import 'package:ronas_assistant/src/blocs/introduce/events/base_introduce_event.dart';

class UpdateLastNameEvent extends BaseIntroduceEvent {
  String value;

  UpdateLastNameEvent(this.value);
}