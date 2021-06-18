import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({
    required this.remoteLoadSurveys,
    required this.localLoadSurveys,
  });

  Future<void> load() async {
    final surveys = await remoteLoadSurveys.load();
    await localLoadSurveys.save(surveys);
  }
}
