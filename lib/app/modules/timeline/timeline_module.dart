import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/timeline/submodules/filtro_module.dart';
import 'package:auto_care_plus_app/app/modules/timeline/timeline_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimelineModule extends Module {
  @override
  List<Module> get imports => [VeiculoModule()];

  @override
  void binds(Injector i) {
    i.add<IAtividadeRepository>(AtividadeRepository.new);
    i.add<IAtividadeService>(AtividadeService.new);
    i.add<AtividadeController>(AtividadeController.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const TimelineScreen());

    r.module('/$filtroRoute', module: FiltroModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
