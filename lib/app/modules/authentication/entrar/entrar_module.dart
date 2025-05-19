import 'package:auto_care_plus_app/app/modules/authentication/entrar/entrar_screen.dart';
import 'package:auto_care_plus_app/app/modules/authentication/recuperar_senha/recuperar_senha_module.dart';
import 'package:auto_care_plus_app/app/modules/bottom_bar/bottom_bar_module.dart';
import 'package:auto_care_plus_app/app/modules/home/home_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntrarModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const EntrarScreen());

    r.module('/$recuperarSenhaRoute', module: RecuperarSenhaModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.module('/$homeRoute', module: HomeModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.module('/$configuracaoRoute', module: BottomBarModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));


    super.routes(r);
  }
}
