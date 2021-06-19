import '../../../shared/routes/routes.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../../../main/composites/composites.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl(AppRoutes.surveys),
  );
}

LoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

//FIXME - Estranho não pode utilizar o makeLocalLoadSurveys() e makeRemoteLoadSurveys(), uma vez que ambos são LoadSurveys..
LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remoteLoadSurveys: RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl(AppRoutes.surveys),
    ),
    localLoadSurveys: LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter()),
  );
}
