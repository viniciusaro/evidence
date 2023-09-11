import 'package:spec/features/login/interaction/login_interaction.dart';

import '../presentation/login_presentation.gen.dart';

class LoginInteractor {
  Stream<LoginState> generate(LoginInteractions interaction) {
    switch (interaction) {
      case LoginInteractions.authenticate:
        throw 1;
    }
  }
}
