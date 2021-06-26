import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../data/models/models.dart';
import '../../../data/http/http.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({required this.httpClient, required this.url});

  @override
  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final json = await httpClient.request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
