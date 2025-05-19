import 'package:auto_care_plus_app/app/modules/mapa/mapa_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MapaModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const MapaScreen());

    super.routes(r);
  }
}
