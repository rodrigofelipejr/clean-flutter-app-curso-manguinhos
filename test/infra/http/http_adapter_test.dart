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
  }) async {
    await client.post(Uri.parse(url));
  }
}

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #ClientMock)])
main() {
  group('post', () {
    test('should call post with correct values', () async {
      final client = ClientMock();
      final sut = HttpAdapter(client);
      final url = '${faker.internet.httpUrl()}/';

      await sut.request(url: url, method: 'post');

      verify(client.post(Uri.parse(url))).called(1);
    });
  });
}
