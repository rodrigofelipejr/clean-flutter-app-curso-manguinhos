import '../../data/models/models.dart';
import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<LocalSurveyAnswerModel>((json) => LocalSurveyAnswerModel.fromJson(json)).toList(),
    );
  }

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) => LocalSurveyResultModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers:
            entity.answers.map<LocalSurveyAnswerModel>((answer) => LocalSurveyAnswerModel.fromEntity(answer)).toList(),
      );

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: this.surveyId,
        question: this.question,
        answers: this.answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      );

  Map toJson() => {
        'surveyId': this.surveyId,
        'question': this.question,
        'answers': this.answers.map<Map>((answer) => answer.toJson()).toList()
      };
}
