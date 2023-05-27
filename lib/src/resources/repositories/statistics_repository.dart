import 'dart:async';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:ronas_assistant/src/resources/api_providers/ronas_it_api_provider.dart';

class StatisticsRepository {
  final ronasITApiProvider = RonasITApiProvider.getInstance();
  static StatisticsRepository? _instance;

  Statistic? _statistic;

  getTime(String userName) {
    if (_statistic == null) {
      return refreshTime(userName);
    }

    return _statistic;
  }

  getTimeByDateRange(String userName, DateTime from, DateTime to) {
    return ronasITApiProvider.userStat(userName, from, to);
  }

  Future<Statistic> refreshTime(String userName) async {
    Statistic statistic = await ronasITApiProvider.fetchTime(userName);

    _statistic = statistic;

    return statistic;
  }

  resetCache() {
    _statistic = null;
  }

  factory StatisticsRepository.getInstance() => _instance ??= StatisticsRepository._internal();

  StatisticsRepository._internal();
}