abstract class Validation {
  ValidationErro? validate({required String field, required String value});
}

enum ValidationErro {
  requiredField,
  invalidField,
}
 class Controller {
   
 }