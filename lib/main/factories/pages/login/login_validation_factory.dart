import '../../../../main/composites/composites.dart';
import '../../../../main/builders/validation_builder.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../../presentation/dependencies/dependencies.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
      //NOTE - Consumindo o designer partner builder
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().min(5).build(),
    ];
