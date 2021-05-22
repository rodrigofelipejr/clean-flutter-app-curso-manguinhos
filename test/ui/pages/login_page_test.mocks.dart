// Mocks generated by Mockito 5.0.7 from annotations
// in fordev/test/ui/pages/login_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:fordev/ui/pages/login/login_presenter.dart' as _i3;
import 'package:get/get_rx/src/rx_types/rx_types.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeRxnString extends _i1.Fake implements _i2.RxnString {}

class _FakeRxBool extends _i1.Fake implements _i2.RxBool {}

/// A class which mocks [LoginPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class LoginPresenterMock extends _i1.Mock implements _i3.LoginPresenter {
  LoginPresenterMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RxnString get emailError =>
      (super.noSuchMethod(Invocation.getter(#emailError),
          returnValue: _FakeRxnString()) as _i2.RxnString);
  @override
  _i2.RxnString get passwordError =>
      (super.noSuchMethod(Invocation.getter(#passwordError),
          returnValue: _FakeRxnString()) as _i2.RxnString);
  @override
  _i2.RxnString get mainError =>
      (super.noSuchMethod(Invocation.getter(#mainError),
          returnValue: _FakeRxnString()) as _i2.RxnString);
  @override
  _i2.RxBool get isFormValid =>
      (super.noSuchMethod(Invocation.getter(#isFormValid),
          returnValue: _FakeRxBool()) as _i2.RxBool);
  @override
  _i2.RxBool get isLoading => (super.noSuchMethod(Invocation.getter(#isLoading),
      returnValue: _FakeRxBool()) as _i2.RxBool);
  @override
  void validateEmail(String? email) =>
      super.noSuchMethod(Invocation.method(#validateEmail, [email]),
          returnValueForMissingStub: null);
  @override
  void validatePassword(String? password) =>
      super.noSuchMethod(Invocation.method(#validatePassword, [password]),
          returnValueForMissingStub: null);
  @override
  _i4.Future<void> auth() => (super.noSuchMethod(Invocation.method(#auth, []),
      returnValue: Future<void>.value(null),
      returnValueForMissingStub: Future.value()) as _i4.Future<void>);
}
