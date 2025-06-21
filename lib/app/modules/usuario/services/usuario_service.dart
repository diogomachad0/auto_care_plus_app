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
    print('=== USUARIO SERVICE - SAVE OR UPDATE ===');
    print('Salvando usuário: ${usuario.nome} - ${usuario.email}');

    final savedUser = await super.saveOrUpdate(usuario, uri: uri);
    print('✅ Usuário salvo no banco local');

    try {
      await updateFirebaseProfile(savedUser);
      print('✅ Perfil Firebase sincronizado');
    } catch (e) {
      print('⚠️ Aviso: Não foi possível sincronizar com Firebase: $e');
      if (e.toString().contains('Um email de verificação foi enviado')) {
        rethrow;
      }
    }

    return savedUser;
  }

  @override
  Future<void> updateFirebaseProfile(UsuarioModel usuario) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        print('⚠️ Usuário não autenticado no Firebase, pulando sincronização');
        return;
      }

      print('=== ATUALIZANDO PERFIL NO FIREBASE ===');
      print('Nome atual: ${firebaseUser.displayName} -> Novo: ${usuario.nome}');
      print('Email atual: ${firebaseUser.email} -> Novo: ${usuario.email}');

      if (firebaseUser.displayName != usuario.nome) {
        await firebaseUser.updateDisplayName(usuario.nome);
        print('✅ Nome atualizado no Firebase');
      }

      if (firebaseUser.email != usuario.email) {
        print('📧 Iniciando alteração de email...');

        await firebaseUser.verifyBeforeUpdateEmail(usuario.email);
        print('✅ Email de verificação enviado para: ${usuario.email}');

        throw Exception('Um email de verificação foi enviado para ${usuario.email}. Verifique sua caixa de entrada para confirmar a alteração.');
      }

      await firebaseUser.reload();
      print('✅ Perfil Firebase atualizado com sucesso');
    } catch (e) {
      print('❌ Erro ao atualizar perfil Firebase: $e');

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

      print('=== ATUALIZANDO SENHA NO FIREBASE ===');

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      print('✅ Reautenticação realizada');

      await user.updatePassword(newPassword);
      print('✅ Senha atualizada no Firebase');
    } catch (e) {
      print('❌ Erro ao atualizar senha: $e');

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

      print('=== EXCLUINDO CONTA ===');

      final localUser = await getCurrentUser();
      if (localUser != null) {
        await delete(localUser);
        print('✅ Usuário excluído do banco local');
      }

      await user.delete();
      print('✅ Conta excluída do Firebase');
    } catch (e) {
      print('❌ Erro ao excluir conta: $e');
      throw Exception('Erro ao deletar conta do Firebase: $e');
    }
  }
}
