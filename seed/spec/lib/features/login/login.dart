import 'package:spec/core.dart';
import 'package:spec/sources.dart';

import 'presentation/login_presentation.dart';

class Login implements Spec {
  @override
  SpecType get type => SpecType.feature;

  @override
  Source get source => LoginSource();

  @override
  Presentation get presentation => LoginPresentation();
}