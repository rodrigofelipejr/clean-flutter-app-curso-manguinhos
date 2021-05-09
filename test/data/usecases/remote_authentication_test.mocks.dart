// Mocks generated by Mockito 5.0.7 from annotations
// in fordev/test/data/usecases/remote_authentication_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/data/http/http_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

/// A class which mocks [HttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class HttpClientMock extends _i1.Mock implements _i2.HttpClient {
  HttpClientMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<dynamic, dynamic>> request(
          {String? url, String? method, Map<dynamic, dynamic>? body}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #request, [], {#url: url, #method: method, #body: body}),
              returnValue:
                  Future<Map<dynamic, dynamic>>.value(<dynamic, dynamic>{}))
          as _i3.Future<Map<dynamic, dynamic>>);
}
