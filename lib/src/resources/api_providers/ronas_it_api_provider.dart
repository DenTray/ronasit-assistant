import 'dart:convert';
import '../../../auth/secrets.dart';
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:ronas_assistant/src/resources/api_providers/base_api_provider.dart';

class RonasITApiProvider extends BaseApiProvider {
  static RonasITApiProvider? _instance;

  String _token = '';
  int _tokenExpiration = 0;

  @override
  String getBaseURL() {
    return 'https://api.ronasit.com/api';
  }

  Future<Statistic> fetchTime(String username) async {
    final response = await apiCall('get', '/report/$username', authRequired: true);

    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }

    return Statistic.fromJson(jsonDecode(response.body));
  }

  dynamic userStat(String username) {
    return apiCall('get', '/stat/$username', authRequired: true);
  }

  dynamic _auth() {
    return apiCall('post', '/auth', body: {
      'email': ronasit_api_login,
      'password': ronasit_api_password
    });
  }

  dynamic apiCall(String type, String url, { body, headers, authRequired = false }) async {
    headers = headers ?? getJsonApiHeaders();

    if (authRequired) {
      if (_token.isEmpty || _tokenExpiration - 2000 < Helpers.now()) {
        await _setToken();
      }

      headers['Authorization'] = 'Bearer $_token';
    }

    return makeRequest(type, url, params: body, headers: headers);
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