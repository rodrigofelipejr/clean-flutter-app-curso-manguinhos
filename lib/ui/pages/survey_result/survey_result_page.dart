import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/constants/constants.dart';
import '../../../ui/helpers/helpers.dart';

class SurveyResultPage extends StatefulWidget {
  final SurveyResultPresenter? presenter;

  const SurveyResultPage({this.presenter, Key? key}) : super(key: key);

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.strings.surveys)),
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter!.loadData();

          return StreamBuilder<dynamic>(
              stream: widget.presenter!.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error.toString(),
                    reload: widget.presenter!.loadData,
                  );
                }

                if (snapshot.hasData) {
                  return ListView.builder(
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
                  );
                }

                return SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
