import 'package:spec/core.dart';
import 'package:spec/domain.dart';

class LoginSource implements Source {
  List<Resource> get resources => [
        LoginVerificationResource(),
        LoginAuthenticationResource(),
      ];
}

class LoginVerificationResource implements Resource<LoginVerificationResult> {
  @override
  Stream<LoginVerificationResult> produce() {
    throw UnimplementedError();
  }
}

class LoginAuthenticationResource implements Resource<LoginAuthenticationResult> {
  @override
  Stream<LoginAuthenticationResult> produce() {
    throw UnimplementedError();
  }
}
