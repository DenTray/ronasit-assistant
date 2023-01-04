import 'package:ronas_assistant/src/support/helpers.dart';

class TotalHours {
  late double _today;
  late double _week;
  late double _month;

  TotalHours.fromJson(Map<String, dynamic> parsedJson) {
    _today = Helpers.convertToDouble(parsedJson['today']);
    _week = Helpers.convertToDouble(parsedJson['week']);
    _month = Helpers.convertToDouble(parsedJson['month']);
  }

  double get today => _today;
  double get week => _week;
  double get month => _month;
}