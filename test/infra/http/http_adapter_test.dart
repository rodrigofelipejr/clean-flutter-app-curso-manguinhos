import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:fordev/infra/http/http.dart';
import 'package:fordev/data/http/http.dart';

import 'http_adapter_test.mocks.dart';

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
    PostExpectation mockRequest() => when(
          client.post(any, body: anyNamed('body'), headers: anyNamed('headers')),
        );

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('should call post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});
      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));
    });

    test('should call post without body', () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key": "any_value"});
    });

    test('should return empty if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('should return empty if post returns 204 with no data', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('should return empty if post returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('should return BadRequestError if post returns 400 (body empty)', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
