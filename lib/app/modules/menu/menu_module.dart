import 'package:auto_care_plus_app/app/modules/menu/menu_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const MenuScreen());

    r.module('/$veiculoRoute', module: VeiculoModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    super.routes(r);
  }
}
