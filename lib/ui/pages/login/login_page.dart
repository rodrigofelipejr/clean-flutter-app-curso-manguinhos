import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../constants/constants.dart';

import 'components/components.dart';
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
                  child: Provider<LoginPresenter>(
                    create: (context) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          SizedBox(height: 8.0),
                          PasswordInput(),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
