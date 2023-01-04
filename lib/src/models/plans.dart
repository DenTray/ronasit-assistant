import 'package:ronas_assistant/src/support/helpers.dart';

class Plans {
  late int _week;
  late int _month;

  Plans.fromJson(Map<String, dynamic> parsedJson) {
    _week = Helpers.convertToInt(parsedJson['week']);
    _month = Helpers.convertToInt(parsedJson['month']);
  }

  int get week => _week;
  int get month => _month;
}