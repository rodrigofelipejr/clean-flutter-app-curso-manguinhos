import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
      percent: int.parse(json['percent']),
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: this.image,
        answer: this.answer,
        isCurrentAnswer: this.isCurrentAnswer,
        percent: this.percent,
      );
}
