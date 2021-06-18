import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remoteLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({required this.remoteLoadSurveys});

  Future<void> load() async {
    await remoteLoadSurveys.load();
  }
}
