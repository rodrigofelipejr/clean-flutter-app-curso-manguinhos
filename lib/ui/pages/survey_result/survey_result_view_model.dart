import 'package:equatable/equatable.dart';

import 'package:fordev/ui/pages/survey_result/survey_answer_view_model.dart';

class SurveyResultViewModel extends Equatable {
  final String surveysId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    required this.surveysId,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => ['id', 'question', 'date', 'didiAnswer'];
}
