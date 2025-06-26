import 'package:auto_care_plus_app/app/modules/sobre/sobre_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SobreModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SobreScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
