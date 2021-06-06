abstract class Validation {
  ValidationErro? validate({required String field, required Map input});
}

enum ValidationErro {
  requiredField,
  invalidField,
}

class Controller {}
