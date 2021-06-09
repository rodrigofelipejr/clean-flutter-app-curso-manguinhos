// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/validation/validators/validation_composite_test.dart.
// Do not manually edit this file.

import 'package:fordev/presentation/dependencies/validation.dart' as _i3;
import 'package:fordev/validation/dependencies/field_validation.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [FieldValidation].
///
/// See the documentation for Mockito's code generation for more information.
class FieldValidationMock extends _i1.Mock implements _i2.FieldValidation {
  FieldValidationMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get field =>
      (super.noSuchMethod(Invocation.getter(#field), returnValue: '')
          as String);
  @override
  _i3.ValidationErro? validate(Map<dynamic, dynamic>? input) =>
      (super.noSuchMethod(Invocation.method(#validate, [input]))
          as _i3.ValidationErro?);
}
