import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:ronas_assistant/src/support/types/time.dart';

class StatisticState {
  bool isLoading = false;

  Time todayTime = Time();
  Time todayRemainTime = Time();
  Time weekTime = Time();
  Time weekRemainTime = Time();
  Time monthTime = Time();
  Time monthRemainTime = Time();

  Time dayPlan = Time().fromDouble(8);
  int weekPlan = 40;
  int monthPlan = 160;

  bool isRemainModeEnabled = false;
  bool isContributionRequired = false;

  Statistic? statistic;
  int? preferableWorkingDaysCount;
  double refreshIconAngle = 1;

  StatisticState({ Statistic? statistic, int? preferableWorkingDaysCount, bool? isRemainModeEnabled, bool isLoading = false, double refreshIconAngle = 1 }) {
    this.statistic = statistic;
    this.isLoading = isLoading;
    this.refreshIconAngle = refreshIconAngle;
    this.preferableWorkingDaysCount = preferableWorkingDaysCount;

    if (statistic != null) {
      todayTime = Time().fromDouble(statistic.totalHours.today);
      weekTime = Time().fromDouble(statistic.totalHours.week);
      monthTime = Time().fromDouble(statistic.totalHours.month);

      weekPlan = statistic.plans.week;
      monthPlan = statistic.plans.month;

      if (preferableWorkingDaysCount != null) {
        dayPlan = calculateDailyPlan(weekPlan, preferableWorkingDaysCount);
      }

      todayRemainTime = dayPlan.sub(todayTime);
      weekRemainTime = Time().fromDouble(weekPlan.toDouble()).sub(weekTime);
      monthRemainTime = Time().fromDouble(monthPlan.toDouble()).sub(monthTime);

      isContributionRequired = todayTime.gte(1) && statistic.contributions.today == 0;
    }

    if (isRemainModeEnabled != null) {
      this.isRemainModeEnabled = isRemainModeEnabled;
    }
  }

  Time calculateDailyPlan(int weekPlan, int preferableWorkingDaysCount) {
    if (weekTime.toDouble() >= weekPlan) {
      return Time().fromDouble(0);
    }

    int currentDayWeek = DateTime.now().weekday;

    int daysLeft = preferableWorkingDaysCount - currentDayWeek + 1;
    double hoursLeft = weekPlan - weekTime.toDouble() + todayTime.toDouble();

    if (daysLeft <= 0) {
      daysLeft = 1;
    }

    return Time().fromDouble(hoursLeft / daysLeft);
  }

  StatisticState copyWith({
    bool? isLoading = false,
    Statistic? statistic,
    int? preferableWorkingDaysCount,
    bool? isRemainModeEnabled,
    double? refreshIconAngle
  }) {
    return StatisticState(
      isLoading: isLoading ?? this.isLoading,
      statistic: statistic ?? this.statistic,
      preferableWorkingDaysCount: preferableWorkingDaysCount ?? this.preferableWorkingDaysCount,
      isRemainModeEnabled: isRemainModeEnabled ?? this.isRemainModeEnabled,
      refreshIconAngle: refreshIconAngle ?? this.refreshIconAngle
    );
  }
}