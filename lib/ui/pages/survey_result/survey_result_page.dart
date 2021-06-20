import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class SurveyResultPage extends StatefulWidget {
  const SurveyResultPage({Key? key}) : super(key: key);

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Container(
        child: Text('Result'),
      ),
    );
  }
}
