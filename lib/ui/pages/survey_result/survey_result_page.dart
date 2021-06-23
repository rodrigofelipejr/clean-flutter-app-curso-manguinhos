import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/routes/routes.dart';
import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/helpers/helpers.dart';

import 'components/survey_result.dart';

class SurveyResultPage extends StatefulWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter, {Key? key}) : super(key: key);

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
          widget.presenter.isLoadingStream.listen((isLoading) async {
            await Future.delayed(Duration(milliseconds: 500));

            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.isSessionExpiredStream.listen((isExpired) async {
            if (isExpired == true) {
              Get.offAllNamed(AppRoutes.login);
            }
          });

          widget.presenter.loadData();

          return StreamBuilder<SurveyResultViewModel?>(
            stream: widget.presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: widget.presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return SurveyResult(viewModel: snapshot.data!);
              }

              return SizedBox(height: 0);
            },
          );
        },
      ),
    );
  }
}
