class Time {
  int _hours = 0;
  int _minutes = 0;
  bool _isPositive = true;

  bool get isPositive => _isPositive;

  Time fromDouble(double hours) {
    _hours = hours.truncate();
    _minutes = ((hours - _hours) * 60).round();

    _isPositive = hours >= 0;

    return this;
  }

  double toDouble() {
    return _hours + _minutes / 60;
  }

  @override
  String toString() {
    return '${_hours.abs()}:${_minutes.abs().toString().padLeft(2, '0')}';
  }

  bool gte(double hours) {
    return toDouble() >= hours;
  }

  bool lte(double hours) {
    return _hours <= hours;
  }

  Time sub(Time time) {
    return Time().fromDouble(toDouble() - time.toDouble());
  }
}