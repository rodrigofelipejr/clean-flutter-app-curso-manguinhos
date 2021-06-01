import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/components/components.dart';

import 'components/components.dart';
import 'sign_up_presenter.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error.description);
            }
          });

          presenter.navigateToStream.listen((page) {
            //NOTE - diferente de null e vazio
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page!);
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(child: LoginHeader()),
                  Column(
                    children: [
                      Headline1(text: R.strings.signUp.toUpperCase()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32.0, 6.0, 32.0, 16.0),
                        child: Provider<SignUpPresenter>(
                          create: (context) => presenter,
                          child: Form(
                            child: Column(
                              children: [
                                NameInput(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: EmailInput(),
                                ),
                                PasswordInput(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PasswordConfirmationInput(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
                                  child: SignUpButton(),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.exit_to_app),
                                  label: Text(R.strings.login),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
