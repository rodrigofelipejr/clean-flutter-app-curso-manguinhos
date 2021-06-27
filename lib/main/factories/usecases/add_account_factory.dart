import '../../../shared/routes/routes.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl(ApiRoutes.signUp),
  );
}
