import 'dart:async';
import 'exchange_rate_api_provider.dart';
import '../models/currencies_response.dart';
import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/exchange.dart';

class CurrenciesRepository {
  final exchangeRateApiProvider = ExchangeRateApiProvider.getInstance();
  static CurrenciesRepository? _instance;

  Future<List<Currency>> getCurrencies() async {
    dynamic response = await exchangeRateApiProvider.fetchCurrenciesList();

    CurrenciesResponse currenciesResponse = CurrenciesResponse.fromJson(response);

    return currenciesResponse.currencies;
  }

  Future<Exchange> getExchange(String fromCurrency, String toCurrency, { double amount = 1 }) async {
    dynamic response = await exchangeRateApiProvider.getExchange(fromCurrency, toCurrency, amount);

    return Exchange.fromJson(response);
  }

  factory CurrenciesRepository.getInstance() => _instance ??= CurrenciesRepository._internal();

  CurrenciesRepository._internal();
}