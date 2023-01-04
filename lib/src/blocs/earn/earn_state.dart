import 'package:ronas_assistant/src/models/statistic.dart';

class EarnState {
  late bool isLoading;
  late Statistic? statistic;
  late double refreshIconAngle;
  late double rate = 1;

  double todayEarned = 0;
  double todayEarnedRub = 0;
  double weekEarned = 0;
  double weekEarnedRub = 0;
  double monthEarned = 0;
  double monthEarnedRub = 0;

  double rubQuote = 70;

  EarnState({ Statistic? statistic, bool isLoading = false, double refreshIconAngle = 1, double rate = 1 }) {
    this.rate = rate;
    this.statistic = statistic;
    this.isLoading = isLoading;
    this.refreshIconAngle = refreshIconAngle;

    if (statistic != null) {
      todayEarned = statistic.totalHours.today * rate;
      todayEarnedRub = todayEarned * rubQuote;

      weekEarned = statistic.totalHours.week * rate;
      weekEarnedRub = weekEarned * rubQuote;

      monthEarned = statistic.totalHours.month * rate;
      monthEarnedRub = monthEarned * rubQuote;
    }
  }

  EarnState copyWith({
    bool? isLoading = false,
    Statistic? statistic,
    double? refreshIconAngle,
    double? rate
  }) {
    return EarnState(
      rate: rate ?? this.rate,
      isLoading: isLoading ?? this.isLoading,
      statistic: statistic ?? this.statistic,
      refreshIconAngle: refreshIconAngle ?? this.refreshIconAngle
    );
  }
}