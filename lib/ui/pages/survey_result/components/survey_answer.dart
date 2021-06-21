import 'package:flutter/material.dart';

import '../../../../ui/constants/constants.dart';
import '../survey_answer_view_model.dart';
import './components.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel answer;

  const SurveyAnswer({
    Key? key,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      List<Widget> children = []..addAll([
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                answer.answer,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              answer.percent,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColorDark,
              ),
            ),
          ),
          answer.isCurrentAnswer ? ActiveIcon() : DisableIcon(),
        ]);

      if (answer.image != null)
        children.insert(
          0,
          Image.network(answer.image!, height: 38.0),
        );

      return children;
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
