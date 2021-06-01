// Mocks generated by Mockito 5.0.8 from annotations
// in fordev/test/ui/pages/sign_up_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/ui/helpers/errors/ui_error.dart' as _i4;
import 'package:fordev/ui/pages/sign_up/sign_up_presenter.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [SignUpPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class SignUpPresenterMock extends _i1.Mock implements _i2.SignUpPresenter {
  SignUpPresenterMock() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.UiError?> get nameErrorStream => (super.noSuchMethod(
      Invocation.getter(#nameErrorStream),
      returnValue: Stream<_i4.UiError?>.empty()) as _i3.Stream<_i4.UiError?>);
  @override
  _i3.Stream<_i4.UiError?> get emailErrorStream => (super.noSuchMethod(
      Invocation.getter(#emailErrorStream),
      returnValue: Stream<_i4.UiError?>.empty()) as _i3.Stream<_i4.UiError?>);
  @override
  _i3.Stream<_i4.UiError?> get passwordErrorStream => (super.noSuchMethod(
      Invocation.getter(#passwordErrorStream),
      returnValue: Stream<_i4.UiError?>.empty()) as _i3.Stream<_i4.UiError?>);
  @override
  _i3.Stream<_i4.UiError?> get passwordConfirmationErrorStream =>
      (super.noSuchMethod(Invocation.getter(#passwordConfirmationErrorStream),
              returnValue: Stream<_i4.UiError?>.empty())
          as _i3.Stream<_i4.UiError?>);
  @override
  _i3.Stream<_i4.UiError?> get mainErrorStream => (super.noSuchMethod(
      Invocation.getter(#mainErrorStream),
      returnValue: Stream<_i4.UiError?>.empty()) as _i3.Stream<_i4.UiError?>);
  @override
  _i3.Stream<bool> get isFormValidStream =>
      (super.noSuchMethod(Invocation.getter(#isFormValidStream),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  _i3.Stream<bool> get isLoadingStream =>
      (super.noSuchMethod(Invocation.getter(#isLoadingStream),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  void validateName(String? email) =>
      super.noSuchMethod(Invocation.method(#validateName, [email]),
          returnValueForMissingStub: null);
  @override
  void validateEmail(String? email) =>
      super.noSuchMethod(Invocation.method(#validateEmail, [email]),
          returnValueForMissingStub: null);
  @override
  void validatePassword(String? password) =>
      super.noSuchMethod(Invocation.method(#validatePassword, [password]),
          returnValueForMissingStub: null);
  @override
  void validatePasswordConfirmation(String? password) => super.noSuchMethod(
      Invocation.method(#validatePasswordConfirmation, [password]),
      returnValueForMissingStub: null);
  @override
  _i3.Future<void> signUp() =>
      (super.noSuchMethod(Invocation.method(#signUp, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
}
