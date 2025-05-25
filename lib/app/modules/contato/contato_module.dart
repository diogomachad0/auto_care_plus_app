import 'package:auto_care_plus_app/app/modules/contato/contato_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContatoModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ContatoScreen());

    super.routes(r);
  }
}
