import '../../../main/composites/composites.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('/surveys/$surveyId/results'),
  );
}

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

//FIXME - Estranho não pode utilizar o makeLocalLoadSurveys() e makeRemoteLoadSurveys(), uma vez que ambos são LoadSurveys..
LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
    remote: RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('/surveys/$surveyId/results'),
    ),
    local: LocalLoadSurveyResult(
      cacheStorage: makeLocalStorageAdapter(),
    ),
  );
}
