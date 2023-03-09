import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:currency_formatter/currency_formatter.dart';

class EarnState {
  late bool isLoading;
  late Statistic? statistic;
  late double refreshIconAngle;
  late double rate = 1;
  late List<Currency>? currencies;
  late List<String>? currenciesNames;

  int? currencyIndex;
  Currency? currency;
  double quote = 1;

  double todayEarned = 0;
  String formattedTodayEarned = '0';
  double weekEarned = 0;
  String formattedWeekEarned = '0';
  double monthEarned = 0;
  String formattedMonthEarned = '0';

  EarnState({
    Statistic? statistic,
    bool isLoading = false,
    double refreshIconAngle = 1,
    double rate = 1,
    List<Currency>? currencies,
    Currency? currency,
    double quote = 1,
  }) {
    this.rate = rate;
    this.statistic = statistic;
    this.isLoading = isLoading;
    this.currencies = currencies;
    this.refreshIconAngle = refreshIconAngle;

    this.quote = quote;

    if (currency != null) {
      this.currency = currency;
    } else if (currencies != null) {
      this.currency = currencies[0];
    }

    bool hasCurrencyFormatter = this.currency != null && CurrencyFormatter.majors[this.currency!.symbol.toLowerCase()] != null;

    if (statistic != null) {
      todayEarned = statistic.totalHours.today * rate;
      double todayEarnedInCurrency = todayEarned * quote;
      formattedTodayEarned = getFormattedMoneyString(hasCurrencyFormatter, todayEarnedInCurrency, this.currency);

      weekEarned = statistic.totalHours.week * rate;
      double weekEarnedInCurrency = weekEarned * quote;
      formattedWeekEarned = getFormattedMoneyString(hasCurrencyFormatter, weekEarnedInCurrency, this.currency);

      monthEarned = statistic.totalHours.month * rate;
      double monthEarnedInCurrency = monthEarned * quote;
      formattedMonthEarned = getFormattedMoneyString(hasCurrencyFormatter, monthEarnedInCurrency, this.currency);
    }

    if (currencies != null) {
      currenciesNames = currencies.map((Currency currency) => currency.name).toList();
    }
  }

  EarnState copyWith({
    bool? isLoading = false,
    Statistic? statistic,
    double? refreshIconAngle,
    double? rate,
    double? quote,
    List<Currency>? currencies,
    Currency? currency
  }) {
    return EarnState(
      rate: rate ?? this.rate,
      quote: quote ?? this.quote,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      statistic: statistic ?? this.statistic,
      currencies: currencies ?? this.currencies,
      refreshIconAngle: refreshIconAngle ?? this.refreshIconAngle
    );
  }

  String getFormattedMoneyString(bool hasCurrencyFormatter, double amount, Currency? currency) {
    return (hasCurrencyFormatter && currency != null) ? CurrencyFormatter.format(amount, CurrencyFormatter.majors[currency.symbol.toLowerCase()]!).toString() : amount.toStringAsFixed(2);
  }
}