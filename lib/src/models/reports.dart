import 'package:ronas_assistant/src/models/report.dart';

class Reports {
  final List<Report> _today = [];
  final List<Report> _week = [];
  final List<Report> _month = [];

  Reports.fromJson(Map<String, dynamic> parsedJson) {
    for (int i = 0; i < parsedJson['today'].length; i++) {
      Report result = Report.fromJson(parsedJson['today'][i]);
      _today.add(result);
    }

    for (int i = 0; i < parsedJson['week'].length; i++) {
      Report result = Report.fromJson(parsedJson['week'][i]);
      _week.add(result);
    }

    for (int i = 0; i < parsedJson['month'].length; i++) {
      Report result = Report.fromJson(parsedJson['month'][i]);
      _month.add(result);
    }
  }

  List<Report> get today => _today;
  List<Report> get week => _week;
  List<Report> get month => _month;
}