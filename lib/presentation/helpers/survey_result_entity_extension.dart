import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

//NOTE - Uso das extensions para novas implementações que são pertinentes a dados da UI...
//as Entities não necessitam de saber tal lógica

extension SurveyResultEntityExtension on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
        surveysId: surveyId,
        question: question,
        answers: answers.map((answer) => answer.toViewModel()).toList(),
      );
}

extension SurveyAnswerEntityExtension on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: '$percent%',
      );
}
