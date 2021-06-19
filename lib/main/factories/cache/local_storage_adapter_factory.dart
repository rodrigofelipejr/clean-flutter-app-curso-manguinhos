import 'package:localstorage/localstorage.dart';

import '../../../infra/cache/local_storage_adapter.dart';

LocalStorageAdapter makeLocalStorageAdapter() => LocalStorageAdapter(localStorage: LocalStorage('fordev'));
