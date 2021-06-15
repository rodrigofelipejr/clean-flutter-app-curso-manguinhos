import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.decoratee,
  });

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});
    final resultRequest = await decoratee.request(url: url, method: method, headers: authorizedHeaders);
    return resultRequest;
  }
}
