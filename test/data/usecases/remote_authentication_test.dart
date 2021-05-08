import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  //TODO verificar https://github.com/dart-lang/mockito/issues/403
  Future<void>? request({
    required String url,
    required String method,
  });
}

class HttpClientMock extends Mock implements HttpClient {}

main() {
  test('should call HttpClient with correct URL', () async {
    final httpClient = HttpClientMock();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    await sut.auth();
    verify(httpClient.request(url: url, method: 'post'));
  });
}
