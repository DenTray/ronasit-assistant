import 'package:ronas_assistant/src/blocs/archive/events/base_archive_event.dart';

class ChangeDateFromEvent extends BaseArchiveEvent {
  DateTime date;

  ChangeDateFromEvent(this.date);
}