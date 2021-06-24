// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/data/usecases/load_survey_result/local_load_survey_result_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/data/cache/cache_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [CacheStorage].
///
/// See the documentation for Mockito's code generation for more information.
class CacheStorageMock extends _i1.Mock implements _i2.CacheStorage {
  CacheStorageMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<dynamic> fetch(String? key) =>
      (super.noSuchMethod(Invocation.method(#fetch, [key]),
          returnValue: Future<dynamic>.value()) as _i3.Future<dynamic>);
  @override
  _i3.Future<void> delete(String? key) =>
      (super.noSuchMethod(Invocation.method(#delete, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> save({String? key, dynamic value}) => (super.noSuchMethod(
      Invocation.method(#save, [], {#key: key, #value: value}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}
