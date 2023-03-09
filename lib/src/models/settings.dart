class Settings {
  late final String _language;
  late final int _preferredWorkingDaysCount;
  late final bool _isRemainModeEnabled;
  late final double _rate;
  late final String _rateCurrency;
  late final int _exchangeCurrencySymbolIndex;

  Settings(
      this._preferredWorkingDaysCount,
      this._language,
      this._isRemainModeEnabled,
      this._rate,
      this._rateCurrency,
      this._exchangeCurrencySymbolIndex
  );

  String get language => _language;
  int get preferredWorkingDaysCount => _preferredWorkingDaysCount;
  bool get isRemainModeEnabled => _isRemainModeEnabled;
  double get rate => _rate;
  String get rateCurrency => _rateCurrency;
  int get exchangeCurrencySymbolIndex => _exchangeCurrencySymbolIndex;
}