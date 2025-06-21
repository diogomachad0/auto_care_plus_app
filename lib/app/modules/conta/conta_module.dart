import 'package:auto_care_plus_app/app/modules/conta/conta_controller.dart';
import 'package:auto_care_plus_app/app/modules/conta/conta_screen.dart';
import 'package:auto_care_plus_app/app/modules/usuario/usuario_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContaModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];

  @override
  void binds(Injector i) {
    i.add<ContaController>(ContaController.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ContaScreen());

    super.routes(r);
  }
}
