
import 'package:auto_care_plus_app/app/modules/bottom_bar/bottom_bar_screen.dart';
import 'package:auto_care_plus_app/app/modules/home/home_module.dart';
import 'package:auto_care_plus_app/app/modules/menu/menu_module.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BottomBarModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => BottomBarScreen(disableNavigationMenu: r.args.data?['disable'] ?? false), children: [
      ModuleRoute('/$homeRoute', module: HomeModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
      ModuleRoute('/$menuRoute', module: MenuModule(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300)),
    ]);
  }
}