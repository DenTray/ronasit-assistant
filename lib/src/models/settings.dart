class Settings {
  late final String _language;
  late final int _preferredWorkingDaysCount;
  late final bool _isRemainModeEnabled;
  late final double _rate;
  late final int _rateCurrencyIndex;
  late final int _displayedCurrencySymbolIndex;

  Settings(
      this._preferredWorkingDaysCount,
      this._language,
      this._isRemainModeEnabled,
      this._rate,
      this._rateCurrencyIndex,
      this._displayedCurrencySymbolIndex
  );

  String get language => _language;
  int get preferredWorkingDaysCount => _preferredWorkingDaysCount;
  bool get isRemainModeEnabled => _isRemainModeEnabled;
  double get rate => _rate;
  int get rateCurrencyIndex => _rateCurrencyIndex;
  int get displayedCurrencySymbolIndex => _displayedCurrencySymbolIndex;
}