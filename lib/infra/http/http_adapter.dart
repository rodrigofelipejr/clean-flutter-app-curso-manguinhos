import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fordev/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final Map<String, String> defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });

    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = http.Response('', 500);

    try {
      switch (method) {
        case 'post':
          response = await client.post(Uri.parse(url), headers: defaultHeaders, body: jsonBody);
          break;
        case 'get':
          response = await client.get(Uri.parse(url), headers: defaultHeaders);
          break;
        default:
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }
}
