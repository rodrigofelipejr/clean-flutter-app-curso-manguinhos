import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/main/decorators/decorators.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/http/http_client.dart';
import 'package:fordev/data/cache/cache.dart';

import 'authorize_http_client_decorator_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FetchSecureCacheStorage>(as: #FetchSecureCacheStorageMock),
  MockSpec<HttpClient>(as: #HttpClientMock),
])
main() {
  late AuthorizeHttpClientDecorator sut;
  late HttpClientMock httpClient;
  late FetchSecureCacheStorageMock fetchSecureCacheStorage;
  late String token;
  late String url;
  late String method;
  late Map body;
  late String httpResponse;

  PostExpectation mockTokenCall() => when(fetchSecureCacheStorage.fetchSecure(any));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    token = faker.guid.guid();
    mockTokenCall().thenThrow(Exception());
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageMock();
    httpClient = HttpClientMock();

    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );

    url = faker.internet.httpUrl();
    method = 'post';
    body = {'any_key': 'any_value'};

    mockToken(); // mock token
    mockHttpResponse(); // mock success
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token}));

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token, 'any_header': 'any_value'},
    )).called(1);
  }, skip: true);

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);
    expect(response, httpResponse);
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws', () async {
    mockTokenError();
    final feature = sut.request(url: url, method: method, body: body);
    expect(feature, throwsA(HttpError.forbidden));
  });
}
