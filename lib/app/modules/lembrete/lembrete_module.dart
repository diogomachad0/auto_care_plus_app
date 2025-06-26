import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_controller.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_screen.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/repositories/lembrete_repository.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/repositories/lembrete_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/services/lembrete_service.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/services/lembrete_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/submodules/adicionar_lembrete/adicionar_lembrete_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LembreteModule extends Module {
  @override
  void binds(Injector i) {
    i.add<ILembreteRepository>(LembreteRepository.new);
    i.add<ILembreteService>(LembreteService.new);
    i.add<LembreteController>(LembreteController.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const LembreteScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    r.module('/$adicioanarLembreteRoute', module: AdicionarLembreteModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
