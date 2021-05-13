import 'package:flutter/material.dart';

import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/constants/constants.dart';

class LoginPage extends StatelessWidget {
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Icon(
                            Icons.email,
                            color: AppColors.kPrimaryColorLight,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Icon(
                            Icons.lock,
                            color: AppColors.kPrimaryColorLight,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text('Entrar'.toUpperCase()),
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
