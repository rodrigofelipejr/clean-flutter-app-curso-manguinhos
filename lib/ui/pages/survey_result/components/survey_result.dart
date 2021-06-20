import 'package:flutter/material.dart';

import '../../../../ui/pages/survey_result/survey_result.dart';
import '../../../../ui/constants/constants.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({required this.viewModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              color: AppColors.kDisableColor.withAlpha(100),
            ),
            child: Text(
              viewModel.question,
              textAlign: TextAlign.center,
            ),
          );

        final answer = viewModel.answers[index - 1];

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.kWhite,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (answer.image != null)
                    Image.network(
                      answer.image!,
                      height: 38.0,
                    ),
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
                ],
              ),
            ),
            Divider(height: 1),
          ],
        );
      },
    );
  }
}

//FIXME - refactor
class ActiveIcon extends StatelessWidget {
  const ActiveIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: AppColors.kSecondaryColor,
    );
  }
}

//FIXME - refactor
class DisableIcon extends StatelessWidget {
  const DisableIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: AppColors.kDisableColor,
    );
  }
}
