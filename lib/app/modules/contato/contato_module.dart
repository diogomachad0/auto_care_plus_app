import 'package:auto_care_plus_app/app/modules/contato/contato_controller.dart';
import 'package:auto_care_plus_app/app/modules/contato/contato_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContatoModule extends Module {
  @override
  void binds(Injector i) {
    i.add<ContatoController>(ContatoController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ContatoScreen());
    super.routes(r);
  }
}
