import 'dart:async';
import '../models/statistic.dart';
import 'ronas_it_api_provider.dart';

class StatisticRepository {
  final ronasITApiProvider = RonasITApiProvider.getInstance();
  static StatisticRepository? _instance;

  Statistic? _statistic;

  getTime(String userName) {
    if (_statistic == null) {
      return refreshTime(userName);
    }

    return _statistic;
  }

  Future<Statistic> refreshTime(String userName) async {
    Statistic statistic = await ronasITApiProvider.fetchTime(userName);

    _statistic = statistic;

    return statistic;
  }

  resetCache() {
    _statistic = null;
  }

  factory StatisticRepository.getInstance() => _instance ??= StatisticRepository._internal();

  StatisticRepository._internal();
}