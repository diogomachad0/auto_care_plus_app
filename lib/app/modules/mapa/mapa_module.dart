import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/mapa/mapa_controller.dart';
import 'package:auto_care_plus_app/app/modules/mapa/mapa_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MapaModule extends Module {
  @override
  void binds(Injector i) {
    i.add<MapaController>(MapaController.new);
    i.add<AtividadeController>(AtividadeController.new);
    i.add<IAtividadeService>(AtividadeService.new);
    i.add<IAtividadeRepository>(AtividadeRepository.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => MapaScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
