import 'package:flutter/material.dart';

import '../../../../ui/pages/survey_result/components/components.dart';
import '../../../../ui/pages/survey_result/survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final Future<void> Function({required String answer}) onSave;

  const SurveyResult({
    required this.viewModel,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return SurveyHeader(question: viewModel.question);
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
          onTap: () => answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
          child: SurveyAnswer(answer: answer),
        );
      },
    );
  }
}
