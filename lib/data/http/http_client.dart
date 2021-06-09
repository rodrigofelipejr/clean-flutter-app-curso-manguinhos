abstract class HttpClient<T> {
  Future<T> request({
    required String url,
    required String method,
    Map body,
  });
}
