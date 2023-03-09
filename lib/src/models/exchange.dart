class Exchange {
  late String _date;
  late double _rate;

  Exchange.fromJson(Map<String, dynamic> parsedJson) {
    _date = parsedJson['date'];
    _rate = parsedJson['result'];
  }

  String get date => _date;
  double get rate => _rate;
}