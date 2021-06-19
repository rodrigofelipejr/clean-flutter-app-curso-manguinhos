import '../../domain/entities/entities.dart';

class SurveyResultEntity {
  final String surveysId;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.surveysId,
    required this.question,
    required this.didAnswer,
    required this.answers,
  });
}
