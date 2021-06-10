import 'package:flutter/material.dart';

import '../survey_view_model.dart';

import '../../../../ui/constants/constants.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  const SurveyItem(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.kSecondaryColorDark,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: viewModel.didAnswer ? AppColors.kGreyShadow : AppColors.kPrimaryColorDark,
              offset: const Offset(0, 4.0),
              blurRadius: 8.0,
              spreadRadius: -2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              viewModel.date,
              style: AppTextStyles.kSurveysDate,
            ),
            Text(
              viewModel.question,
              style: AppTextStyles.kSurveysDescription,
            ),
          ],
        ),
      ),
    );
  }
}
