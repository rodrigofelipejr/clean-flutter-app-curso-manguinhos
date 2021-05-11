import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final http.Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
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
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));
    });
  });
}
