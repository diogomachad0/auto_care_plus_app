import 'package:auto_care_plus_app/app/modules/atividade/atividade_controller.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/home/home_controller.dart';
import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [VeiculoModule()];

  @override
  void binds(Injector i) {
    i.add<IAtividadeRepository>(AtividadeRepository.new);
    i.add<IAtividadeService>(AtividadeService.new);
    i.add<AtividadeController>(AtividadeController.new);

    i.add<HomeController>(HomeController.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const HomeScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
