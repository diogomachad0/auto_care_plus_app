import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VeiculoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const VeiculoScreen());

    super.routes(r);
  }
}
