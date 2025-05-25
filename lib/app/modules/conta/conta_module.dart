import 'package:auto_care_plus_app/app/modules/conta/conta_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContaModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const ContaScreen());

    super.routes(r);
  }
}
