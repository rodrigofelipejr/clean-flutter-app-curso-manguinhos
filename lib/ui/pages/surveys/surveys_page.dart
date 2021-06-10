import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter? presenter;

  const SurveysPage(this.presenter, {Key? key}) : super(key: key);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  void initState() {
    widget.presenter!.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 1,
              ),
              items: [
                SurveyItem(),
                SurveyItem(),
                SurveyItem(),
              ],
            ),
          );
        },
      ),
    );
  }
}
