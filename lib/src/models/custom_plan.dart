class CustomPlan {
  late int _plan;
  late String _name;
  late String _createdAt;

  CustomPlan.fromJson(Map<String, dynamic> parsedJson) {
    _plan = parsedJson['plan'];
    _name = parsedJson['name'];
    _createdAt = parsedJson['created_at'];
  }

  int get plan => _plan;
  String get name => _name;
  String get createdAt => _createdAt;
}