import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const HomeScreen());

    super.routes(r);
  }
}
