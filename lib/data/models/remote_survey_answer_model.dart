import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAccountAnswer,
    required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: this.image,
        answer: this.answer,
        isCurrentAnswer: this.isCurrentAccountAnswer.toString(),
        percent: this.percent,
      );
}
