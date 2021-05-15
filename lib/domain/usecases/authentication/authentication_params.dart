import 'package:equatable/equatable.dart';

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  AuthenticationParams({required this.email, required this.secret});

  @override
  List<Object?> get props => [email, secret];
}
