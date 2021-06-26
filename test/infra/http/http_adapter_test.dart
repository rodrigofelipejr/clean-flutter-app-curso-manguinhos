import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:fordev/infra/http/http.dart';
import 'package:fordev/data/http/http.dart';

import 'http_adapter_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #ClientMock)])
main() {
  late HttpAdapter sut;
  late ClientMock client;
  late String url;

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('Shared', () {
    test('Should throw ServerError if invalid method is provider', () async {
      final future = sut.request(url: url, method: 'invalid_method');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('Post', () {
    PostExpectation mockRequest() => when(
          client.post(any, body: anyNamed('body'), headers: anyNamed('headers')),
        );

    void mockResponse(int statusCode, {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});
      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
        headers: {'any_header': 'any_value'},
      );
      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value',
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key": "any_value"});
    });

    test('Should return empty if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('Should return empty if post returns 204 with no data', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('Should return empty if post returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, {});
    });

    test('Should return BadRequestError if post returns 400 (body empty)', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('Get', () {
    PostExpectation mockRequest() => when(
          client.get(any, headers: anyNamed('headers')),
        );

    void mockResponse(int statusCode, {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call get with correct values', () async {
      await sut.request(url: url, method: 'get');
      verify(client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      ));

      await sut.request(url: url, method: 'get', headers: {'any_header': 'any_value'});
      verify(client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'any_header': 'any_value',
        },
      ));
    });

    test('Should return data if get returns 200', () async {
      final response = await sut.request(url: url, method: 'get');
      expect(response, {"any_key": "any_value"});
    });

    test('Should return empty if get returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'get');
      expect(response, isEmpty);
    });

    test('Should return empty if get returns 204 with no data', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'get');
      expect(response, {});
    });

    test('Should return empty if get returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'get');
      expect(response, {});
    });

    test('Should return BadRequestError if get returns 400 (body empty)', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if get returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if get returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if get returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'get');
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('Put', () {
    PostExpectation mockRequest() => when(
          client.put(any, body: anyNamed('body'), headers: anyNamed('headers')),
        );

    void mockResponse(int statusCode, {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call put with correct values', () async {
      await sut.request(url: url, method: 'put', body: {'any_key': 'any_value'});
      verify(client.put(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
        url: url,
        method: 'put',
        body: {'any_key': 'any_value'},
        headers: {'any_header': 'any_value'},
      );
      verify(client.put(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value',
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call put without body', () async {
      await sut.request(url: url, method: 'put');
      verify(client.put(any, headers: anyNamed('headers')));
    });

    test('Should return data if put returns 200', () async {
      final response = await sut.request(url: url, method: 'put');
      expect(response, {"any_key": "any_value"});
    });

    test('Should return empty if put returns 200 with no data', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'put');
      expect(response, {});
    });

    test('Should return empty if put returns 204 with no data', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'put');
      expect(response, {});
    });

    test('Should return empty if put returns 204 with data', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'put');
      expect(response, {});
    });

    test('Should return BadRequestError if put returns 400 (body empty)', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if put returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if put returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if put returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if put returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if put returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if put throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'put');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
