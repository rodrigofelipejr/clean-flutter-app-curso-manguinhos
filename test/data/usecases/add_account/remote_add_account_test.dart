import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import './remote_add_account_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
main() {
  late RemoteAddAccount sut;
  late HttpClientMock httpClient;
  late String url;
  late AddAccountParams params;

  PostExpectation mockRequest() =>
      when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    await sut.add(params: params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'name': params.name,
      'email': params.email,
      'password': params.password,
      'passwordConfirmation': params.passwordConfirmation,
    }));
  });

  test('should throw UnexpectedError if HttpClient return 400', () async {
    mockHttpError(HttpError.badRequest);
    final future = sut.add(params: params);
    expect(future, throwsA(DomainError.unexpected));
  });
}
