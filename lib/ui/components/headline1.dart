import 'package:flutter/material.dart';

import 'package:fordev/ui/constants/constants.dart';

class Headline1 extends StatelessWidget {
  final String text;

  const Headline1({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.kHeadline1,
    );
  }
}
