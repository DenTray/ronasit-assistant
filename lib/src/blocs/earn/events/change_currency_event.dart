import './base_earn_event.dart';

class ChangeCurrencyEvent extends BaseEarnEvent {
  late int currencyIndex;

  ChangeCurrencyEvent(this.currencyIndex);
}