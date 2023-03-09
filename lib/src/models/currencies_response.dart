import 'package:ronas_assistant/src/models/currency.dart';

class CurrenciesResponse {
  late List<Currency> _currencies;

  CurrenciesResponse.fromJson(Map<String, dynamic> parsedJson) {
    _currencies = [];

    parsedJson['symbols'].forEach((key, value) => _currencies.add(Currency.fromJson(value)));
  }

  List<Currency> get currencies => _currencies;
}