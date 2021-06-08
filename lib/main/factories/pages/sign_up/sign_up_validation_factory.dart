import '../../../builders/validation_builder.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/validators/validators.dart';

Validation makeSignUpValidation() => ValidationComposite(makeSignUpValidations());

List<FieldValidation> makeSignUpValidations() => [
      //NOTE - Consumindo o designer partner builder
      ...ValidationBuilder.field('name').required().min(3).build(),
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().min(5).build(),
      ...ValidationBuilder.field('passwordConfirmation').required().min(5).sameAs('password').build(),
    ];
