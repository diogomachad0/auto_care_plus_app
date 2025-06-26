import 'package:auto_care_plus_app/app/modules/authentication/registro/registro_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegistroModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const RegistroScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
