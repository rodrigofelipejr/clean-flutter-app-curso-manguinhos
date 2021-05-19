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
  test('Should return null if all validations returns null or empty', () {
    final validation1 = FieldValidationMock();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);

    final validation2 = FieldValidationMock();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');

    final sut = ValidationComposite();

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
}
