import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/validation/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

import 'validation_composite_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<FieldValidation>(as: #FieldValidationMock)])
main() {
  late FieldValidationMock validation1;
  late FieldValidationMock validation2;
  late FieldValidationMock validation3;
  late ValidationComposite sut;

  void mockValidation1(ValidationErro? error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(ValidationErro? error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(ValidationErro? error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationMock();
    when(validation1.field).thenReturn('other_field');
    mockValidation1(null);

    validation2 = FieldValidationMock();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationMock();
    when(validation3.field).thenReturn('any_field');
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return the first error', () {
    mockValidation1(ValidationErro.requiredField);
    mockValidation2(ValidationErro.requiredField);
    mockValidation3(ValidationErro.invalidField);
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, ValidationErro.requiredField);
  });
}
