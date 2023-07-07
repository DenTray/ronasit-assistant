import 'package:ronas_assistant/src/blocs/archive/events/base_archive_event.dart';

class ApplySortEvent extends BaseArchiveEvent {
  ApplySortEvent(this.currentSortingIndex);

  int currentSortingIndex;
}