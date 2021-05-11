import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fordev/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final responseEmpty = {};
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty ? responseEmpty : jsonDecode(response.body);
    } else {
      return responseEmpty;
    }
  }
}
