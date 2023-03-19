import 'package:intl/intl.dart';
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
  String finishTime = '';

  Time dayPlan = Time.fromDouble(hours: 8);
  Time weekPlan = Time.fromDouble(hours: 40);
  Time monthPlan = Time.fromDouble(hours: 160);

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
      todayTime = Time.fromDouble(hours: statistic.totalHours.today);
      weekTime = Time.fromDouble(hours: statistic.totalHours.week);
      monthTime = Time.fromDouble(hours: statistic.totalHours.month);

      weekPlan = Time.fromDouble(hours: statistic.plans.week.toDouble());
      monthPlan = Time.fromDouble(hours: statistic.plans.month.toDouble());

      if (preferableWorkingDaysCount != null) {
        dayPlan = calculateDailyPlan(weekPlan, preferableWorkingDaysCount);
      }

      todayRemainTime = dayPlan.sub(todayTime);
      weekRemainTime = weekPlan.sub(weekTime);
      monthRemainTime = monthPlan.sub(monthTime);

      DateTime now = DateTime.now().add(Duration(minutes: (todayRemainTime.toDouble() * 60).toInt()));
      finishTime = DateFormat('kk:mm').format(now);

      isContributionRequired = todayTime.gte(1) && statistic.contributions.today == 0;
    }

    if (isRemainModeEnabled != null) {
      this.isRemainModeEnabled = isRemainModeEnabled;
    }
  }

  Time calculateDailyPlan(Time weekPlan, int preferableWorkingDaysCount) {
    int currentDayWeek = DateTime.now().weekday;

    int daysLeft = preferableWorkingDaysCount - currentDayWeek + 1;
    double hoursLeft = weekPlan.toDouble() - weekTime.toDouble() + todayTime.toDouble();

    if (daysLeft < 0 && weekTime.gte(weekPlan.toDouble())) {
      return Time();
    }

    if (daysLeft <= 0) {
      daysLeft = 1;
    }

    return Time.fromDouble(hours: hoursLeft / daysLeft);
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