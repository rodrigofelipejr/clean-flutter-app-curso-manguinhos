import 'package:flutter/material.dart';

import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/constants/constants.dart';

import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(text: 'Login'.toUpperCase()),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                      stream: presenter.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Icon(
                                Icons.email,
                                color: AppColors.kPrimaryColorLight,
                              ),
                            ),
                            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter.validateEmail,
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    StreamBuilder<String?>(
                      stream: presenter.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            icon: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Icon(
                                Icons.lock,
                                color: AppColors.kPrimaryColorLight,
                              ),
                            ),
                            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: presenter.validatePassword,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
                      child: StreamBuilder<bool>(
                        stream: presenter.isFormValidStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.data == true ? () {} : null,
                            child: Text('Entrar'.toUpperCase()),
                          );
                        },
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      label: Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
