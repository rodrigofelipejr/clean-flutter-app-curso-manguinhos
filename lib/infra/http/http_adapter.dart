import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fordev/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  Map _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else {
      throw HttpError.badRequest;
    }
  }

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    return _handleResponse(response);
  }
}
