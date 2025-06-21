import 'package:auto_care_plus_app/app/modules/usuario/models/usuario_model.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service_interface.dart';

abstract class IUsuarioService implements IService<UsuarioModel> {
  Future<UsuarioModel?> getByEmail(String email);

  Future<UsuarioModel?> getCurrentUser();

  Future<void> validateCurrentPassword(String currentPassword);

  Future<void> updateFirebaseProfile(UsuarioModel usuario);

  Future<void> updatePassword(String currentPassword, String newPassword);

  Future<void> deleteAccount();
}
