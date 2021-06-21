import 'package:flutter/material.dart';

import '../../../../ui/pages/survey_result/components/components.dart';
import '../../../../ui/pages/survey_result/survey_result.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({required this.viewModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return SurveyHeader(question: viewModel.question);

        return SurveyAnswer(answer: viewModel.answers[index - 1]);
      },
    );
  }
}
