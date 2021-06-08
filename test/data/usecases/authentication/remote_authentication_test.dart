import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'remote_authentication_test.mocks.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
main() {
  late RemoteAuthentication sut;
  late HttpClientMock httpClient;
  late String url;
  late AuthenticationParams params;

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() =>
      when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    await sut.auth(params: params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('should throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw InvalidCredentialsError if HttpClient return 401', () async {
    mockHttpError(HttpError.unauthorized);
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return an Account if HttpClient return 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);
    final account = await sut.auth(params: params);
    expect(account.token, validData['accessToken']);
  });

  test('should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});
    final future = sut.auth(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
