import 'package:auto_care_plus_app/app/modules/atividade/atividade_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtividadeModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AtividadeScreen());

    super.routes(r);
  }
}
