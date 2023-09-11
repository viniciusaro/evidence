import 'package:flutter/material.dart';
import 'package:spec/features/login/flutter/login_screen.dart';
import 'package:spec/features/login/flutter/login_state.dart';

class LoginInteractor extends StatelessWidget {
  const LoginInteractor({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      state: LoginStateRegular(),
      onSubmitButtonTapped: (context) {
        //
      },
    );
  }
}
