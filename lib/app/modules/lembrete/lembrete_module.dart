import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_screen.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/submodules/adicionar_lembrete/adicionar_lembrete_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LembreteModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const LembreteScreen());


    r.module('/$adicioanarLembreteRoute', module: AdicionarLembreteModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
