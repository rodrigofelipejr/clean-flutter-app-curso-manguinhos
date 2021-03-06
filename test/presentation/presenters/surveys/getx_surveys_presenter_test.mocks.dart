// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/presentation/presenters/surveys/getx_surveys_presenter_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/domain/entities/survey_entity.dart' as _i4;
import 'package:fordev/domain/usecases/surveys/load_surveys.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [LoadSurveys].
///
/// See the documentation for Mockito's code generation for more information.
class LoadSurveysMock extends _i1.Mock implements _i2.LoadSurveys {
  LoadSurveysMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.SurveyEntity>> load() =>
      (super.noSuchMethod(Invocation.method(#load, []),
              returnValue:
                  Future<List<_i4.SurveyEntity>>.value(<_i4.SurveyEntity>[]))
          as _i3.Future<List<_i4.SurveyEntity>>);
}
