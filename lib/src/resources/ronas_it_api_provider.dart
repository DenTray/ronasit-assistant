import 'dart:convert';
import '../../auth/secrets.dart';
import 'package:http/http.dart' show Client;
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:ronas_assistant/src/models/statistic.dart';

class RonasITApiProvider {
  static RonasITApiProvider? _instance;

  final Client _client = Client();
  String _token = '';
  int _tokenExpiration = 0;

  Future<Statistic> fetchTime(String username) async {
    final response = await _makeRequest('get', 'https://api.ronasit.com/api/report/$username', authRequired: true);

    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }

    return Statistic.fromJson(jsonDecode(response.body));
  }

  dynamic userStat(String username) {
    return _makeRequest('get', 'https://api.ronasit.com/api/stat/$username', authRequired: true);
  }

  dynamic _auth() {
    return _makeRequest('post', 'https://api.ronasit.com/api/auth', body: {
      'email': ronasit_api_login,
      'password': ronasit_api_password
    });
  }

  Map<String, String> getJsonApiHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  dynamic _makeRequest(String type, String url, { body, headers, authRequired = false }) async {
    Uri uri = Uri.parse(url);
    headers = headers ?? getJsonApiHeaders();

    if (body != null) {
      body = jsonEncode(body);
    }

    if (authRequired) {
      if (_token.isEmpty || _tokenExpiration - 2000 < Helpers.now()) {
        await _setToken();
      }

      headers['Authorization'] = 'Bearer $_token';
    }

    if (type == 'post') {
      return _client.post(uri, headers: headers, body: body);
    }

    if (type == 'get') {
      return _client.get(uri, headers: headers);
    }
  }

  _setToken() async {
    var response = await _auth();

    Map<String, dynamic> authResponse = jsonDecode(response.body);

    _token = authResponse['token'];
    _tokenExpiration = Helpers.now() + 60 * 60 * 1000;
  }

  factory RonasITApiProvider.getInstance() => _instance ??= RonasITApiProvider._internal();

  RonasITApiProvider._internal();
}