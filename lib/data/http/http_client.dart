abstract class HttpClient {
  //TODO verificar https://github.com/dart-lang/mockito/issues/403
  Future<void>? request({
    required String url,
    required String method,
    Map body,
  });
}
