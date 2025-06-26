import 'package:auto_care_plus_app/app/modules/authentication/login/login_module.dart';
import 'package:auto_care_plus_app/app/modules/bottom_bar/bottom_bar_module.dart';
import 'package:auto_care_plus_app/app/modules/splash/splash_controller.dart';
import 'package:auto_care_plus_app/app/modules/splash/splash_screen.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends Module {
  @override
  void binds(Injector i) {
    i.add<SplashController>(SplashController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    r.module('/$loginRoute', module: LoginModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));
    r.module('/$bottomBarRoute', module: BottomBarModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
