import 'package:ronas_assistant/src/blocs/archive/events/base_archive_event.dart';

class ChangeDateToEvent extends BaseArchiveEvent {
  DateTime date;

  ChangeDateToEvent(this.date);
}