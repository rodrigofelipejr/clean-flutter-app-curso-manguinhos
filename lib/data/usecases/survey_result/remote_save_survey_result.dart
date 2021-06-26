import '../../../data/http/http.dart';

class RemoteSaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({required this.httpClient, required this.url});

  Future<void> save({required String answer}) async {
    await httpClient.request(url: url, method: 'put', body: {'answer': answer});
  }
}
