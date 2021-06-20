import 'package:flutter/material.dart';

import '../../../ui/constants/constants.dart';
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
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0)
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0, right: 20.0, left: 20.0),
              decoration: BoxDecoration(
                color: AppColors.kDisableColor.withAlpha(100),
              ),
              child: Text(
                'Qual é seu framework web favorito?',
                textAlign: TextAlign.center,
              ),
            );

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
                    Image.network(AppImage.logoAngular, height: 38.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Angular',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '100%',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kPrimaryColorDark,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: AppColors.kSecondaryColor,
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
            ],
          );
        },
      ),
    );
  }
}
