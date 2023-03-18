import 'dart:convert';
import 'package:ronas_assistant/src/resources/api_providers/base_api_provider.dart';

class ExchangeRateApiProvider extends BaseApiProvider {
  static ExchangeRateApiProvider? _instance;

  dynamic fetchCurrenciesList() async {
    final response = await makeRequest('get', '/symbols');

    return jsonDecode(response.body);
  }

  dynamic getExchange(String fromCurrency, String toCurrency, double amount) async {
    final response = await makeRequest('get', '/convert', params: {
      'from': fromCurrency,
      'to': toCurrency,
      'amount': amount
    });

    return jsonDecode(response.body);
  }

  @override
  String getBaseURL() {
    return 'https://api.exchangerate.host';
  }

  factory ExchangeRateApiProvider.getInstance() => _instance ??= ExchangeRateApiProvider._internal();

  ExchangeRateApiProvider._internal();
}