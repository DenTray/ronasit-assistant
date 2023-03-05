import 'dart:convert';
import 'package:http/http.dart' show Client;

class ExchangeRateApiProvider {
  static ExchangeRateApiProvider? _instance;

  final Client _client = Client();
  final String _baseUrl = 'https://api.exchangerate.host';

  dynamic fetchCurrenciesList() async {
    final response = await _makeRequest('get', '/symbols');

    return jsonDecode(response.body);
  }

  dynamic getExchange(String fromCurrency, String toCurrency, double amount) async {
    final response = await _makeRequest('get', '/convert', params: {
      'from': fromCurrency,
      'to': toCurrency,
      'amount': amount
    });

    return jsonDecode(response.body);
  }

  dynamic _makeRequest(String type, String url, { Map? params }) async {
    url = '$_baseUrl$url';

    if (type == 'post') {
      Object? body;

      if (params != null) {
        body = jsonEncode(body);
      }

      return _client.post(Uri.parse(url), body: body);
    }
//TODO move to the base class
    if (type == 'get') {
      if (params != null) {
        int keyIndex = 1;

        params.keys.toList().forEach((key) {
          dynamic value = params[key];
          String separator = (keyIndex == 1) ? '?' : '&';

          url += '$separator$key=$value';

          keyIndex++;
        });
      }

      return _client.get(Uri.parse(url));
    }
  }

  factory ExchangeRateApiProvider.getInstance() => _instance ??= ExchangeRateApiProvider._internal();

  ExchangeRateApiProvider._internal();
}