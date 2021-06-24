import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: this.image,
        answer: this.answer,
        isCurrentAnswer: this.isCurrentAnswer,
        percent: this.percent,
      );
}
