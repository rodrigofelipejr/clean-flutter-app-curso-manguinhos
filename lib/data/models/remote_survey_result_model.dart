import '../../data/models/models.dart';
import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<RemoteSurveyAnswerModel>((json) => RemoteSurveyAnswerModel.fromJson(json)).toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveysId: this.surveyId,
        question: this.question,
        answers: this.answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      );
}
