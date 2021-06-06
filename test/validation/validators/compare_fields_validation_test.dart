import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/presentation/dependencies/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is null', () {
    expect(sut.validate('wrong_value'), ValidationErro.invalidField);
  });
}
