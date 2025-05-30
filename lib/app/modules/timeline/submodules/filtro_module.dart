import 'package:auto_care_plus_app/app/modules/lembrete/submodules/adicionar_lembrete/adicionar_lembrete_widget.dart';
import 'package:auto_care_plus_app/app/modules/timeline/submodules/filtro_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FiltroModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const FiltroWidget());

    super.routes(r);
  }
}
