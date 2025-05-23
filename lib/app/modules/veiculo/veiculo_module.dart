import 'package:auto_care_plus_app/app/modules/veiculo/submodules/adicionar_veiculo/adicionar_veiculo_module.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VeiculoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const VeiculoScreen());


    r.module('/$adicionarVeiculoRoute', module: AdicionarVeiculoModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
