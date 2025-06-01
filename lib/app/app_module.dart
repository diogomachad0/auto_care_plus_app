import 'package:auto_care_plus_app/app/app_controller.dart';
import 'package:auto_care_plus_app/app/modules/authentication/login/login_module.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_module.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [VeiculoModule(), LembreteModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<AppController>(AppController.new);

    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: LoginModule());

    super.routes(r);
  }
}
