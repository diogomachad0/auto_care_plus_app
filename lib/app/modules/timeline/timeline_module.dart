import 'package:auto_care_plus_app/app/modules/timeline/timeline_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimelineModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const TimelineScreen());

    super.routes(r);
  }
}
