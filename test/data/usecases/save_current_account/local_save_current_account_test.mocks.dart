// Mocks generated by Mockito 5.0.7 from annotations
// in fordev/test/data/usecases/save_current_account/local_save_current_account_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/data/cache/save_secure_cache_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [SaveSecureCacheStorage].
///
/// See the documentation for Mockito's code generation for more information.
class SaveSecureCacheStorageMock extends _i1.Mock
    implements _i2.SaveSecureCacheStorage {
  @override
  _i3.Future<void> saveSecure({String? key, String? value}) =>
      (super.noSuchMethod(
          Invocation.method(#saveSecure, [], {#key: key, #value: value}),
          returnValue: Future<void>.value(null),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}