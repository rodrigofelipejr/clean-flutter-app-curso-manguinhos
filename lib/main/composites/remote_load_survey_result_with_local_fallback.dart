import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
  });

  Future<void> loadBySurvey({String? surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}
