import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/dependencies.dart';
import 'package:fordev/validation/dependencies/field_validation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'validation_composite_test.mocks.dart';

class ValidationComposite implements Validation {
  @override
  String? validate({required String field, required String value}) {
    return null;
  }
}

@GenerateMocks([], customMocks: [MockSpec<FieldValidation>(as: #FieldValidationMock, returnNullOnMissingStub: false)])
main() {
  late FieldValidationMock validation1;
  late FieldValidationMock validation2;
  late FieldValidationMock validation3;
  late ValidationComposite sut;

  void mockValidation1(String? error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String? error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(String? error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationMock();
    when(validation1.field).thenReturn('any_field');
    mockValidation1(null);

    validation2 = FieldValidationMock();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationMock();
    when(validation3.field).thenReturn('other_field');
    mockValidation3(null);

    sut = ValidationComposite();
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation2('');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
}
