import 'package:auto_care_plus_app/app/modules/authentication/recuperar_senha/recuperar_senha_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecuperarSenhaModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const RecuperarSenhaScreen(), transition: TransitionType.fadeIn, duration: const Duration(milliseconds: 300));

    super.routes(r);
  }
}
