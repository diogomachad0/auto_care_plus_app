import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_screen.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/submodules/adicionar_lembrete/adicionar_lembrete_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdicionarLembreteModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const AdicionarLembreteWidget());

    super.routes(r);
  }
}
