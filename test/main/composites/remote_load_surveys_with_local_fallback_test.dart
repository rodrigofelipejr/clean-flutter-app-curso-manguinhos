import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/main/composites/composites.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<RemoteLoadSurveys>(as: #RemoteLoadSurveysMock),
])
main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysMock remote;

  setUp(() {
    remote = RemoteLoadSurveysMock();
    sut = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys: remote);
  });

  test('Should call remote load', () async {
    await sut.load();
    verify(remote.load()).called(1);
  });
}
