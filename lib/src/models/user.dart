class User {
  late final String _fistName;
  late final String _lastName;
  late final String _userName;

  User(this._fistName, this._lastName, this._userName);

  String get fistName => _fistName;
  String get lastName => _lastName;
  String get userName => _userName;
}