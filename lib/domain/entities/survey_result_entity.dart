import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [this.surveyId, this.question, this.answers];
}
