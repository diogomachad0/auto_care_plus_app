import 'package:auto_care_plus_app/app/modules/authentication/entrar/entrar_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntrarModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const EntrarScreen());

    super.routes(r);
  }
}
