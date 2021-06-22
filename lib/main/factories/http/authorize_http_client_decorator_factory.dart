import '../../../data/http/http.dart';
import '../../../main/factories/cache/cache.dart';
import '../../../main/factories/factories.dart';
import '../../../main/decorators/decorators.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: makeLocalStorageSecureAdapter(),
      deleteSecureCacheStorage: makeLocalStorageSecureAdapter(),
      decoratee: makeHttpAdapter(),
    );
