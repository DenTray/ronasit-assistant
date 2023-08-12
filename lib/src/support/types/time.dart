class Time {
  int _hours = 0;
  int _minutes = 0;
  bool _isPositive = true;
  bool _isNegative = false;
  bool _isEmpty = false;

  bool get isPositive => _isPositive;
  bool get isNegative => _isNegative;
  bool get isEmpty => _isEmpty;

  Time({ int hours = 0, int minutes = 0 }) {
    _hours = hours;
    _minutes = minutes;
    _isEmpty = _hours == 0 && _minutes == 0;
    _isPositive = _hours > 0 || _hours == 0 && _minutes > 0;
    _isNegative = _hours < 0 || _hours == 0 && _minutes < 0;
  }

  static Time fromDouble({ double hours = 0}) {
    int hoursCount = hours.truncate();
    int minutesCount = ((hours - hoursCount) * 60).round();

    return Time(hours: hoursCount, minutes: minutesCount);
  }

  double toDouble() {
    return _hours + _minutes / 60;
  }

  @override
  String toString() {
    return '${_hours.abs()}:${_minutes.abs().toString().padLeft(2, '0')}';
  }

  String toInvertedSignedString() {
    return (_isNegative) ? '+${toString()}' : toString();
  }

  bool gte(double hours) {
    return toDouble() >= hours;
  }

  bool lte(double hours) {
    return _hours <= hours;
  }

  Time sub(Time time) {
    return Time.fromDouble(hours: toDouble() - time.toDouble());
  }

  Time add(double hours) {
    return Time.fromDouble(hours: toDouble() + hours);
  }
}