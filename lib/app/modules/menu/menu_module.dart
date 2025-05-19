import 'package:auto_care_plus_app/app/modules/menu/menu_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const MenuScreen());


    super.routes(r);
  }
}
