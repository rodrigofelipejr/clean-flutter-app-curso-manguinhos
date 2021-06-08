import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  SurveyEntity({
    required this.id,
    required this.question,
    required this.dateTime,
    required this.didAnswer,
  });

  @override
  List<Object?> get props => [this.id, this.question, this.dateTime, this.didAnswer];
}
