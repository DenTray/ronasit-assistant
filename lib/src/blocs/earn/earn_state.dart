import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:currency_formatter/currency_formatter.dart';

class EarnState {
  late bool isLoading;
  late double refreshIconAngle;

  late double rate = 1;
  double exchangeRate = 1;
  late Statistic? statistic;

  late List<Currency>? currencies;
  List<String> currenciesNames = [];

  int? displayedCurrencyIndex;
  Currency? displayedCurrency;
  Currency? rateCurrency;

  double todayEarned = 0;
  String formattedTodayEarned = '0';
  double weekEarned = 0;
  String formattedWeekEarned = '0';
  double monthEarned = 0;
  String formattedMonthEarned = '0';

  EarnState({
    Statistic? statistic,
    bool isLoading = true,
    double refreshIconAngle = 1,
    double rate = 1,
    List<Currency>? currencies,
    Currency? displayedCurrency,
    Currency? rateCurrency,
    double exchangeRate = 1,
  }) {
    this.rate = rate;
    this.statistic = statistic;
    this.isLoading = isLoading;
    this.currencies = currencies;
    this.refreshIconAngle = refreshIconAngle;
    this.exchangeRate = exchangeRate;

    if (displayedCurrency != null) {
      this.displayedCurrency = displayedCurrency;
    }

    if (rateCurrency != null) {
      this.rateCurrency = rateCurrency;
    }

    if (currencies != null) {
      currenciesNames = currencies.map((Currency currency) => currency.name).toList();
    }

    if (statistic != null) {
      bool hasCurrencyFormatter = this.displayedCurrency != null && CurrencyFormatter.majors[this.displayedCurrency!.symbol.toLowerCase()] != null;

      todayEarned = statistic.totalHours.today * rate;
      double todayEarnedInCurrency = todayEarned * exchangeRate;
      formattedTodayEarned = getFormattedMoneyString(hasCurrencyFormatter, todayEarnedInCurrency, this.displayedCurrency);

      weekEarned = statistic.totalHours.week * rate;
      double weekEarnedInCurrency = weekEarned * exchangeRate;
      formattedWeekEarned = getFormattedMoneyString(hasCurrencyFormatter, weekEarnedInCurrency, this.displayedCurrency);

      monthEarned = statistic.totalHours.month * rate;
      double monthEarnedInCurrency = monthEarned * exchangeRate;
      formattedMonthEarned = getFormattedMoneyString(hasCurrencyFormatter, monthEarnedInCurrency, this.displayedCurrency);
    }
  }

  EarnState copyWith({
    bool? isLoading = false,
    Statistic? statistic,
    double? refreshIconAngle,
    double? rate,
    double? exchangeRate,
    List<Currency>? currencies,
    Currency? displayedCurrency,
    Currency? rateCurrency,
  }) {
    return EarnState(
      rate: rate ?? this.rate,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      displayedCurrency: displayedCurrency ?? this.displayedCurrency,
      rateCurrency: rateCurrency ?? this.rateCurrency,
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