import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'http_adapter_test.mocks.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

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
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    return jsonDecode(response.body);
  }
}

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #ClientMock, returnNullOnMissingStub: false)])
main() {
  late HttpAdapter sut;
  late ClientMock client;
  late String url;

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test('should call post with correct values', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));
    });

    test('should call post without body', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('should return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {"any_key": "any_value"});
    });
  });
}
