import 'package:auto_care_plus_app/app/modules/authentication/entrar/entrar_module.dart';
import 'package:auto_care_plus_app/app/modules/authentication/login/login_screen.dart';
import 'package:auto_care_plus_app/app/modules/authentication/registro/registro_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const LoginScreen());

    r.module('/$entrarRoute', module: EntrarModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.module('/$registrarRoute', module: RegistroModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
