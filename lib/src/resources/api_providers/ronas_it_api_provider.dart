import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../auth/secrets.dart';
import 'package:ronas_assistant/src/support/helpers.dart';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:ronas_assistant/src/resources/api_providers/base_api_provider.dart';
import '../../models/archive_statistic.dart';

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

    return Statistic.fromJson(jsonDecode(response.body));
  }

  Future<ArchiveStatistic> userStat(String username, DateTime from, DateTime to) async {
    String fromFilter = DateFormat('d-M-y').format(from);
    String toFilter = DateFormat('d-M-y').format(to);

    bool isSingleDayStats = fromFilter == toFilter;

    var body = (isSingleDayStats)
      ? {
        'date': DateFormat('y-M-d').format(from)
      }
      : {
        'date_range': jsonEncode({
          'start': fromFilter,
          'end': toFilter
        })
      };

    final response = await apiCall('get', '/report/$username', authRequired: true, body: body);

    return (isSingleDayStats)
      ? ArchiveStatistic.fromSingleStatistic(jsonDecode(response.body))
      : ArchiveStatistic.fromJson(jsonDecode(response.body));
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

    var response = await makeRequest(type, url, params: body, headers: headers);

    if (response.statusCode >= 400) {
      throw Exception(response.body);
    }

    return response;
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