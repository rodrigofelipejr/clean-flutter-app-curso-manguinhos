import '../../../../domain/helpers/helpers.dart';
import '../../../data/http/http.dart';

class RemoteSaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({required this.httpClient, required this.url});

  Future<void> save({required String answer}) async {
    try {
      await httpClient.request(url: url, method: 'put', body: {'answer': answer});
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
