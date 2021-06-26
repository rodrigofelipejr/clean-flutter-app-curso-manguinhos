// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/presentation/presenters/survey_result/getx_survey_result_presenter_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:fordev/domain/entities/survey_result_entity.dart' as _i2;
import 'package:fordev/domain/usecases/surveys_result/load_survey_result.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeSurveyResultEntity extends _i1.Fake
    implements _i2.SurveyResultEntity {}

/// A class which mocks [LoadSurveyResult].
///
/// See the documentation for Mockito's code generation for more information.
class LoadSurveyResultMock extends _i1.Mock implements _i3.LoadSurveyResult {
  LoadSurveyResultMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.SurveyResultEntity> loadBySurvey({String? surveyId}) => (super
      .noSuchMethod(Invocation.method(#loadBySurvey, [], {#surveyId: surveyId}),
          returnValue: Future<_i2.SurveyResultEntity>.value(
              _FakeSurveyResultEntity())) as _i4
      .Future<_i2.SurveyResultEntity>);
}
