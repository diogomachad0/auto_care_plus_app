import 'package:auto_care_plus_app/app/modules/veiculo/submodules/adicionar_veiculo/adicionar_veiculo_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarVeiculoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AdicionarVeiculoScreen());

    super.routes(r);
  }
}
