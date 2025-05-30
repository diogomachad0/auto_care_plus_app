import 'package:auto_care_plus_app/app/modules/timeline/submodules/filtro_module.dart';
import 'package:auto_care_plus_app/app/modules/timeline/timeline_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimelineModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const TimelineScreen());

    r.module('/$filtroRoute', module: FiltroModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));


    super.routes(r);
  }
}
