import 'package:ronas_assistant/src/models/archive_statistic.dart';

class ArchiveState {
  late bool isLoading;
  late DateTime fromDate;
  late DateTime toDate;
  ArchiveStatistic? statistic;
  late double rate = 1;
  double exchangeRate = 1;
  double earned = 1;
  bool isCustomModeEnabled = false;

  ArchiveState({
    bool this.isLoading = true,
    ArchiveStatistic? statistic = null,
    DateTime? fromDate = null,
    DateTime? toDate = null,
    double this.rate = 1,
    double this.exchangeRate = 1,
    bool this.isCustomModeEnabled = false
  }) {
    if (statistic?.totalHours != null) {
      this.earned = statistic!.totalHours.toDouble() * rate * exchangeRate;
    }

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
    double? exchangeRate,
    double? rate,
    bool? isCustomModeEnabled,
  }) {
    return ArchiveState(
      isLoading: isLoading ?? this.isLoading,
      statistic: statistic ?? this.statistic,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      rate: rate ?? this.rate,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isCustomModeEnabled: isCustomModeEnabled ?? this.isCustomModeEnabled
    );
  }
}