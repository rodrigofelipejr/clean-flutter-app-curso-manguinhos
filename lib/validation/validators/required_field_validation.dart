import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}
