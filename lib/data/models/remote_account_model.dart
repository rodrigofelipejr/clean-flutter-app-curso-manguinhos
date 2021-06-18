import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    final key = 'accessToken';
    if (!json.containsKey(key)) return throw HttpError.invalidData;
    return RemoteAccountModel(json[key]);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
