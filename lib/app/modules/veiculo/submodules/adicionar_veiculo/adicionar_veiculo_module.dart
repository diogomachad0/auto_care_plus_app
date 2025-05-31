import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/submodules/adicionar_veiculo/adicionar_veiculo_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarVeiculoModule extends Module {
  @override
  void routes(RouteManager r) {
    @override
    void binds(Injector i) {
      i.add<IVeiculoRepository>(VeiculoRepository.new);
      i.add<IVeiculoService>(VeiculoService.new);
      i.add<VeiculoController>(VeiculoController.new);

      super.binds(i);
    }


    r.child(Modular.initialRoute, child: (context) => const AdicionarVeiculoScreen());

    super.routes(r);
  }
}
