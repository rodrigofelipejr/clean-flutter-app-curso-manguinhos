// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/infra/cache/local_storage_adapter_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [FlutterSecureStorage].
///
/// See the documentation for Mockito's code generation for more information.
class FlutterSecureStorageMock extends _i1.Mock
    implements _i2.FlutterSecureStorage {
  @override
  _i3.Future<void> write(
          {String? key,
          String? value,
          _i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
          Invocation.method(#write, [], {
            #key: key,
            #value: value,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<String?> read(
          {String? key,
          _i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
          Invocation.method(#read, [], {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions
          }),
          returnValue: Future<String?>.value()) as _i3.Future<String?>);
  @override
  _i3.Future<bool> containsKey(
          {String? key,
          _i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
          Invocation.method(#containsKey, [], {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions
          }),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> delete(
          {String? key,
          _i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
          Invocation.method(#delete, [], {
            #key: key,
            #iOptions: iOptions,
            #aOptions: aOptions,
            #lOptions: lOptions
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<Map<String, String>> readAll(
          {_i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
              Invocation.method(#readAll, [], {
                #iOptions: iOptions,
                #aOptions: aOptions,
                #lOptions: lOptions
              }),
              returnValue:
                  Future<Map<String, String>>.value(<String, String>{}))
          as _i3.Future<Map<String, String>>);
  @override
  _i3.Future<void> deleteAll(
          {_i2.IOSOptions? iOptions = _i2.IOSOptions.defaultOptions,
          _i2.AndroidOptions? aOptions,
          _i2.LinuxOptions? lOptions}) =>
      (super.noSuchMethod(
          Invocation.method(#deleteAll, [],
              {#iOptions: iOptions, #aOptions: aOptions, #lOptions: lOptions}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}
