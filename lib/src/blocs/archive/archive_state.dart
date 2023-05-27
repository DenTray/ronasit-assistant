import 'package:ronas_assistant/src/models/archive_statistic.dart';

class ArchiveState {
  late bool isLoading;
  late DateTime fromDate;
  late DateTime toDate;
  ArchiveStatistic? statistic;

  ArchiveState({
    bool isLoading = true,
    ArchiveStatistic? statistic = null,
    DateTime? fromDate = null,
    DateTime? toDate = null,
  }) {
    this.isLoading = isLoading;

    if (statistic != null) {
      this.statistic = statistic;
    }

    this.fromDate = (fromDate == null) ? DateTime.now().subtract(Duration(days: 1)) : fromDate;
    this.toDate = (toDate == null) ? DateTime.now().subtract(Duration(days: 1)) : toDate;
  }

  ArchiveState copyWith({
    bool? isLoading = false,
    ArchiveStatistic? statistic = null,
    DateTime? fromDate = null,
    DateTime? toDate = null,
  }) {
    return ArchiveState(
      isLoading: isLoading ?? this.isLoading,
      statistic: statistic ?? this.statistic,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate
    );
  }
}