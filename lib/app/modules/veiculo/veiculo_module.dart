import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/submodules/adicionar_veiculo/adicionar_veiculo_module.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VeiculoModule extends Module {
  @override
  void binds(Injector i) {
    i.add<IVeiculoRepository>(VeiculoRepository.new);
    i.add<IVeiculoService>(VeiculoService.new);
    i.add<VeiculoController>(VeiculoController.new);

    super.binds(i);
  }
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const VeiculoScreen());


    r.module('/$adicionarVeiculoRoute', module: AdicionarVeiculoModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
