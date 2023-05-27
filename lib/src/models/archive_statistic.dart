import 'package:ronas_assistant/src/models/custom_plan.dart';
import 'package:ronas_assistant/src/models/report.dart';
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:ronas_assistant/src/support/types/time.dart';

class ArchiveStatistic {
  final List<CustomPlan> _plans = [];
  final List<Report> _reports = [];
  final List<Report> _projects = [];

  int _totalPlan = 0;
  Time _totalHours = Time.fromDouble(hours: 0);

  ArchiveStatistic.fromJson(Map<String, dynamic> parsedJson) {
    for (int i = 0; i < parsedJson['plans']['custom'].length; i++) {
      CustomPlan result = CustomPlan.fromJson(parsedJson['plans']['custom'][i]);

      _plans.add(result);
      _totalPlan += result.plan;
    }

    Map<String, Report> projectMap = {};

    for (int i = 0; i < parsedJson['reports']['custom'].length; i++) {
      Report result = Report.fromJson(parsedJson['reports']['custom'][i]);

      _reports.add(result);
      _totalHours = _totalHours.add(result.hours);

      if (!projectMap.containsKey(result.project)) {
        projectMap.addEntries([MapEntry(result.project, result)]);
      } else {
        projectMap.update(result.project, (value) => Report(
            value.user,
            value.source,
            value.project,
            value.date,
            value.hours + result.hours,
            value.assignmentName
        ));
      }
    }

    _projects.addAll(projectMap.values);
  }

  ArchiveStatistic.fromSingleStatistic(Map<String, dynamic> parsedJson) {
    _totalHours = Time.fromDouble(hours: Helpers.convertToDouble(parsedJson['total_hours']['today']));
    _totalPlan = Helpers.convertToInt(Helpers.convertToInt(parsedJson['plans']['week']) / 5);

    for (int i = 0; i < parsedJson['reports']['today'].length; i++) {
      Report result = Report.fromJson(parsedJson['reports']['today'][i]);

      _projects.add(result);
    }
  }

  List<CustomPlan> get plans => _plans;
  List<Report> get reports => _reports;
  List<Report> get projects => _projects;
  int get totalPlan => _totalPlan;
  Time get totalHours => _totalHours;
}