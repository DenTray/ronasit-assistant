import 'package:ronas_assistant/src/models/plans.dart';
import 'package:ronas_assistant/src/models/reports.dart';
import 'package:ronas_assistant/src/models/total_hours.dart';
import 'package:ronas_assistant/src/models/contributions.dart';

class Statistic {
  late Plans _plans;
  late Reports _reports;
  late String _requestingDate;
  late TotalHours _totalHours;
  late Contributions _contributions;

  Statistic.fromJson(Map<String, dynamic> parsedJson) {
    _requestingDate = parsedJson['requestingDate'];
    _contributions = Contributions.fromJson(parsedJson['contributions']);
    _plans = Plans.fromJson(parsedJson['plans']);
    _totalHours = TotalHours.fromJson(parsedJson['total_hours']);
    _reports = Reports.fromJson(parsedJson['reports']);
  }

  String get requestingDate => _requestingDate;
  Contributions get contributions => _contributions;
  Plans get plans => _plans;
  TotalHours get totalHours => _totalHours;
  Reports get reports => _reports;
}