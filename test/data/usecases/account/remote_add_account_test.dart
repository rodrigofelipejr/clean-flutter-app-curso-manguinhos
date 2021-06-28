import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';
import 'remote_add_account_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
main() {
  late RemoteAddAccount sut;
  late HttpClientMock httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  void mockHttpData(Map data) {
    apiResult = data;
    return mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAddAccount();
    mockHttpData(FakeAccountFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params: params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'name': params.name,
      'email': params.email,
      'password': params.password,
      'passwordConfirmation': params.passwordConfirmation,
    }));
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    mockHttpError(HttpError.notFound);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    mockHttpError(HttpError.serverError);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient return 403', () async {
    mockHttpError(HttpError.forbidden);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final account = await sut.add(params: params);
    expect(account.token, apiResult['accessToken']);
  });
}
