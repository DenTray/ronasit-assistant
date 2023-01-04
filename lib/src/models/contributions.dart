class Contributions {
  late int _today;

  Contributions.fromJson(Map<String, dynamic> parsedJson) {
    _today = parsedJson['today'];
  }

  int get today => _today;
}