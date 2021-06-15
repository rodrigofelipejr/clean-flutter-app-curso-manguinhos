// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/data/usecases/load_surveys/remote_load_surveys_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/data/http/http_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [HttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class HttpClientMock extends _i1.Mock implements _i2.HttpClient {
  HttpClientMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<dynamic> request(
          {String? url,
          String? method,
          Map<dynamic, dynamic>? body,
          Map<dynamic, dynamic>? headers}) =>
      (super.noSuchMethod(
          Invocation.method(#request, [],
              {#url: url, #method: method, #body: body, #headers: headers}),
          returnValue: Future<dynamic>.value()) as _i3.Future<dynamic>);
}
