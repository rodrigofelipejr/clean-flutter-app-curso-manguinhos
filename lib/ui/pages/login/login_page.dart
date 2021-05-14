import 'package:flutter/material.dart';

import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/constants/constants.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
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
                          stream: widget.presenter.emailErrorStream,
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
                              onChanged: widget.presenter.validateEmail,
                            );
                          },
                        ),
                        SizedBox(height: 8.0),
                        StreamBuilder<String?>(
                          stream: widget.presenter.passwordErrorStream,
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
                              onChanged: widget.presenter.validatePassword,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
                          child: StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true ? widget.presenter.auth : null,
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
          );
        },
      ),
    );
  }
}
