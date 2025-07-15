import 'package:auto_care_plus_app/app/modules/usuario/models/usuario_model.dart';
import 'package:auto_care_plus_app/app/modules/usuario/repositories/usuario_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/usuario/services/usuario_services_interface.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService extends BaseService<UsuarioModel, IUsuarioRepository> implements IUsuarioService {
  UsuarioService(super.repository);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UsuarioModel?> getByEmail(String email) async {
    final users = await repository.getAll();
    return users.where((user) => user.email == email).firstOrNull;
  }

  @override
  Future<UsuarioModel?> getCurrentUser() async {
    final users = await repository.getAll();
    return users.isNotEmpty ? users.first : null;
  }

  @override
  Future<UsuarioModel> saveOrUpdate(UsuarioModel usuario, {String? uri}) async {
    final savedUser = await super.saveOrUpdate(usuario, uri: uri);

    try {
      await updateFirebaseProfile(savedUser);
    } catch (e) {
      if (e.toString().contains('Um email de verificação foi enviado')) {
        rethrow;
      }
    }

    return savedUser;
  }

  @override
  Future<void> validateCurrentPassword(String currentPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Senha atual incorreta');
      }
      throw Exception('Erro ao validar senha: $e');
    }
  }

  @override
  Future<void> updateFirebaseProfile(UsuarioModel usuario) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return;
      }

      if (firebaseUser.displayName != usuario.nome) {
        await firebaseUser.updateDisplayName(usuario.nome);
      }

      if (firebaseUser.email != usuario.email) {
        await firebaseUser.verifyBeforeUpdateEmail(usuario.email);

        throw Exception('Um email de verificação foi enviado para ${usuario.email}. Verifique sua caixa de entrada para confirmar a alteração.');
      }

      await firebaseUser.reload();
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        throw Exception('Para alterar dados sensíveis, você precisa fazer login novamente');
      } else if (e.toString().contains('operation-not-allowed')) {
        throw Exception('Esta operação não está habilitada. Verifique as configurações do Firebase');
      } else if (e.toString().contains('invalid-email')) {
        throw Exception('Email inválido');
      } else if (e.toString().contains('email-already-in-use')) {
        throw Exception('Este email já está sendo usado por outra conta');
      } else if (e.toString().contains('too-many-requests')) {
        throw Exception('Muitas tentativas. Tente novamente mais tarde');
      }

      if (e.toString().contains('Um email de verificação foi enviado')) {
        rethrow;
      }

      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  @override
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
    } catch (e) {
      if (e.toString().contains('wrong-password')) {
        throw Exception('Senha atual incorreta');
      }
      throw Exception('Erro ao atualizar senha: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      final localUser = await getCurrentUser();
      if (localUser != null) {
        await delete(localUser);
      }

      await user.delete();
    } catch (e) {
      throw Exception('Erro ao deletar conta do Firebase: $e');
    }
  }
}
