import 'package:ronas_assistant/src/support/helpers.dart';

class Report {
  late String _user;
  late String _source;
  late String _project;
  late String _date;
  late double _hours;
  String? _assignmentName;

  Report(this._user, this._source, this._project, this._date, this._hours, this._assignmentName);

  Report.fromJson(Map<String, dynamic> parsedJson) {
    _user = parsedJson['user'];
    _source = parsedJson['source'];
    _project = "${parsedJson['project'][0].toUpperCase()}${parsedJson['project'].substring(1).toLowerCase()}";
    _date = parsedJson['date'];
    _hours = Helpers.convertToDouble(parsedJson['hours']);
    _assignmentName = parsedJson['assignment_name'];
  }

  String get user => _user;
  String get source => _source;
  String get project => _project;
  String get date => _date;
  double get hours => _hours;
  String? get assignmentName => _assignmentName;

  dynamic getProp(String key) => <String, dynamic> {
    'project' : _project,
    'hours' : _hours
  }[key];
}