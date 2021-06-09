// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/data/usecases/load_current_account/local_load_current_account_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/data/cache/fetch_secure_cache_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [FetchSecureCacheStorage].
///
/// See the documentation for Mockito's code generation for more information.
class FetchSecureCacheStorageMock extends _i1.Mock
    implements _i2.FetchSecureCacheStorage {
  @override
  _i3.Future<String> fetchSecure(String? key) =>
      (super.noSuchMethod(Invocation.method(#fetchSecure, [key]),
          returnValue: Future<String>.value('')) as _i3.Future<String>);
}
