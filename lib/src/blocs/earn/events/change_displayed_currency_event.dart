import './base_earn_event.dart';

class ChangeDisplayedCurrencyEvent extends BaseEarnEvent {
  late int currencyIndex;

  ChangeDisplayedCurrencyEvent(this.currencyIndex);
}