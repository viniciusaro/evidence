import 'package:spec/trail.dart';

import '../presentation/login_presentation.gen.dart';

class LoginScreen extends StatelessWidget {
  final LoginState state;
  final void Function(BuildContext) onSubmitButtonTapped;

  const LoginScreen({
    super.key,
    required this.state,
    required this.onSubmitButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const LoginInputField(),
          const LoginInputField(),
          LoginSubmitButton(isLoading: state.submitButtonLoading),
          const LoginErrorMessage(),
        ],
      ),
    );
  }
}

class LoginInputField extends StatelessWidget {
  const LoginInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrailTextField();
  }
}

class LoginSubmitButton extends StatelessWidget {
  final bool isLoading;
  const LoginSubmitButton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return const TrailButton();
  }
}

class LoginErrorMessage extends StatelessWidget {
  const LoginErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrailText();
  }
}
