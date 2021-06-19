import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SurveyResultEntity extends Equatable {
  final String surveysId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.surveysId,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [this.surveysId, this.question, this.answers];
}
