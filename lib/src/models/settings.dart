class Settings {
  late final String _language;
  late final int _preferredWorkingDaysCount;
  late final bool _isRemainModeEnabled;
  late final double _rate;

  Settings(this._preferredWorkingDaysCount, this._language, this._isRemainModeEnabled, this._rate);

  String get language => _language;
  int get preferredWorkingDaysCount => _preferredWorkingDaysCount;
  bool get isRemainModeEnabled => _isRemainModeEnabled;
  double get rate => _rate;
}