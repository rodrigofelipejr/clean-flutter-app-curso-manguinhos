import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'remote_load_survey_result_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<HttpClient>(as: #HttpClientMock)])
void main() {
  late RemoteSaveSurveyResult sut;
  late HttpClientMock httpClient;
  late String url;
  late String answer;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientMock();
    answer = faker.lorem.sentence();
    sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);
    verify(httpClient.request(url: url, method: 'put', body: {'answer': answer})).called(1);
  });
}
