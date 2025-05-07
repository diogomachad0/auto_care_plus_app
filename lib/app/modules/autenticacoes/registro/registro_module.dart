import 'package:auto_care_plus_app/app/modules/autenticacoes/registro/registro_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegistroModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const RegistroScreen());

    super.routes(r);
  }
}