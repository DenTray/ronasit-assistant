class Currency {
  late String _symbol;
  late String _name;

  Currency.fromJson(Map<String, dynamic> parsedJson) {
    _symbol = parsedJson['code'];
    _name = parsedJson['description'];
  }

  String get symbol => _symbol;
  String get name => _name;
}