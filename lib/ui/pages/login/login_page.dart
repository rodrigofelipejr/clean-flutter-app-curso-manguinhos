import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/components/components.dart';

import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              //NOTE - Get.offAllNamed => remove todas as telas e insere uma nova na pilha
              Get.offAllNamed(page!);
            }
          });

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 340.0),
                      child: LoginHeader(),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Headline1(text: R.strings.login.toUpperCase()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Provider<LoginPresenter>(
                              create: (context) => presenter,
                              child: Form(
                                child: Column(
                                  children: [
                                    EmailInput(),
                                    SizedBox(height: 8.0),
                                    PasswordInput(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
                                      child: LoginButton(),
                                    ),
                                    TextButton.icon(
                                      onPressed: presenter.goToSignUp,
                                      icon: Icon(Icons.person),
                                      label: Text(R.strings.addAccount),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
