import '../support/helpers.dart';

class Exchange {
  late String _date;
  late double _rate;

  Exchange.fromJson(Map<String, dynamic> parsedJson) {
    _date = parsedJson['date'];
    _rate = (parsedJson['result'] != null) ? Helpers.convertToDouble(parsedJson['result']) : 0;
  }

  String get date => _date;
  double? get rate => _rate;
}