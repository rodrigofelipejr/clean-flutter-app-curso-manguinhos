import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/pages/surveys/survey_view_model.dart';
import '../../../ui/components/components.dart';
import '../../../ui/helpers/helpers.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage(this.presenter, {Key? key}) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  void didChangeDependencies() {
    widget.presenter.loadData();
    super.didChangeDependencies();
  }

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

          widget.presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              //NOTE - Get.toNamed => insere uma nova tela na pilha
              Get.toNamed(page!);
            }
          });

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: widget.presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
                  child: SurveyListItems(viewModels: snapshot.data!),
                ); //FIXME - null?
              }

              return SizedBox(height: 0);
            },
          );
        },
      ),
    );
  }
}
