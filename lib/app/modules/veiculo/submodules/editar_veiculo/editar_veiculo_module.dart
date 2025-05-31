import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/submodules/editar_veiculo/editar_veiculo_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditarVeiculoModule extends Module {
  @override
  void routes(RouteManager r) {
    @override
    void binds(Injector i) {
      i.add<IVeiculoRepository>(VeiculoRepository.new);
      i.add<IVeiculoService>(VeiculoService.new);
      i.add<VeiculoController>(VeiculoController.new);

      super.binds(i);
    }

    r.child(Modular.initialRoute, child: (context) => const EditarVeiculoScreen());

    super.routes(r);
  }
}
