import 'dart:async';
import '../exchange_rate_api_provider.dart';
import '../../models/currencies_response.dart';
import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/exchange.dart';

class CurrenciesRepository {
  final exchangeRateApiProvider = ExchangeRateApiProvider.getInstance();
  static CurrenciesRepository? _instance;

  List<Currency>? _currencies;
  Exchange? _exchange;

  getCurrencies() {
    if (_currencies == null) {
      return fetchCurrencies();
    }

    return _currencies;
  }

  getExchange(String fromCurrency, String toCurrency) {
    if (_exchange == null) {
      return fetchExchange(fromCurrency, toCurrency);
    }

    return _exchange;
  }

  Future<List<Currency>> fetchCurrencies() async {
    dynamic response = await exchangeRateApiProvider.fetchCurrenciesList();

    CurrenciesResponse currenciesResponse = CurrenciesResponse.fromJson(response);

    _currencies = currenciesResponse.currencies;

    return currenciesResponse.currencies;
  }

  Future<Exchange> fetchExchange(String fromCurrency, String toCurrency, { double amount = 1 }) async {
    dynamic response = await exchangeRateApiProvider.getExchange(fromCurrency, toCurrency, amount);
    Exchange result = Exchange.fromJson(response);

    _exchange = result;

    return result;
  }

  resetCache() {
    _currencies = null;
    _exchange = null;
  }

  factory CurrenciesRepository.getInstance() => _instance ??= CurrenciesRepository._internal();

  CurrenciesRepository._internal();
}