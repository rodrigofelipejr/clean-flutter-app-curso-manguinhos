import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../../data/models/models.dart';
import '../../../data/http/http.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> add({required AddAccountParams params}) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      final httpResponse = await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams entity) => RemoteAddAccountParams(
        name: entity.name,
        email: entity.email,
        password: entity.password,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map toJson() => {'name': name, 'email': email, 'password': password, 'passwordConfirmation': passwordConfirmation};
}
