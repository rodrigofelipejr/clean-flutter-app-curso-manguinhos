import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';

import '../../../data/http/http.dart';

class RemoteLoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  RemoteLoadSurveys({required this.httpClient, required this.url});

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse.map<SurveyEntity>((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
  }
}
