import '../../../builders/validation_builder.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
      //ANCHOR - Consumindo o designer partner builder
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().min(5).build(),
    ];
