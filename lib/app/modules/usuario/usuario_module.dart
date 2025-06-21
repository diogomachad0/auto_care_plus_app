import 'package:auto_care_plus_app/app/modules/conta/conta_controller.dart';
import 'package:auto_care_plus_app/app/modules/usuario/repositories/usuario_repository.dart';
import 'package:auto_care_plus_app/app/modules/usuario/repositories/usuario_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/usuario/services/usuario_service.dart';
import 'package:auto_care_plus_app/app/modules/usuario/services/usuario_services_interface.dart';
import 'package:auto_care_plus_app/app/modules/usuario/usuario_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UsuarioModule extends Module {
  @override
  void binds(Injector i) {
    i.add<IUsuarioRepository>(UsuarioRepository.new);
    i.add<IUsuarioService>(UsuarioService.new);
    i.add<UsuarioController>(UsuarioController.new);
    i.add<ContaController>(ContaController.new);

    super.binds(i);
  }
}
