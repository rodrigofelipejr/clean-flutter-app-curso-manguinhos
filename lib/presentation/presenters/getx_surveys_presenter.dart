import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:fordev/domain/usecases/usecases.dart';

class GetXSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetXSurveysPresenter({required this.loadSurveys});

  var _isLoading = RxBool(true);
  var _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.subject.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.subject.stream;

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys
        .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer,
            ))
        .toList();
    _isLoading.value = false;
  }
}
