import 'dart:convert';
import 'package:http/http.dart' show Client;

abstract class BaseApiProvider {
  final Client _client = Client();

  String getBaseURL();

  Map<String, String> getJsonApiHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  dynamic makeRequest(String type, String url, { Map? params, headers }) async {
    headers = headers ?? getJsonApiHeaders();

    url = getBaseURL() + url;

    if (type == 'post') {
      Object? body;

      if (params != null) {
        body = jsonEncode(params);
      }

      return _client.post(Uri.parse(url), body: body, headers: headers);
    }

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

      return _client.get(Uri.parse(url), headers: headers);
    }
  }
}