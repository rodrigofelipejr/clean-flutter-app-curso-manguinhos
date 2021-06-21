import 'package:flutter/material.dart';

import '../../../../ui/constants/constants.dart';

class SurveyHeader extends StatelessWidget {
  final String question;

  const SurveyHeader({
    required this.question,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0, right: 20.0, left: 20.0),
      decoration: BoxDecoration(
        color: AppColors.kDisableColor.withAlpha(100),
      ),
      child: Text(
        question,
        textAlign: TextAlign.center,
      ),
    );
  }
}
