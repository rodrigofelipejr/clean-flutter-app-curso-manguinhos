import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../survey_view_model.dart';
import 'components.dart';

class SurveyListItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyListItems({
    required this.viewModels,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: viewModels.map((viewModel) => SurveyItem(viewModel)).toList()),
    );
  }
}
