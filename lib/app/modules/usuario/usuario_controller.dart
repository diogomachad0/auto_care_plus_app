import 'package:auto_care_plus_app/app/modules/usuario/models/usuario_model.dart';
import 'package:auto_care_plus_app/app/modules/usuario/services/usuario_services_interface.dart';
import 'package:auto_care_plus_app/app/modules/usuario/store/usuario_store.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:mobx/mobx.dart';

part 'usuario_controller.g.dart';

class UsuarioController = _UsuarioControllerBase with _$UsuarioController;

abstract class _UsuarioControllerBase with Store {
  final IUsuarioService _service;

  @observable
  UsuarioStore usuario = UsuarioStoreFactory.novo();

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  _UsuarioControllerBase(this._service);

  @action
  Future<void> loadCurrentUser() async {
    try {
      isLoading = true;
      errorMessage = '';

      print('=== CARREGANDO USUÁRIO ATUAL ===');
      final currentUser = await _service.getCurrentUser();
      if (currentUser != null) {
        usuario = UsuarioStoreFactory.fromModel(currentUser);
        print('✅ Usuário carregado: ${usuario.nome} - ${usuario.email}');
      } else {
        print('⚠️ Nenhum usuário encontrado no banco local');
      }
    } catch (e) {
      errorMessage = 'Erro ao carregar dados do usuário: ${e.toString()}';
      print('❌ $errorMessage');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> saveUserFromRegistration(String nome, String email, String telefone, String senha) async {
    try {
      print('=== USUARIO CONTROLLER - SALVANDO DADOS ===');
      print('Nome recebido: $nome');
      print('Email recebido: $email');
      print('Telefone recebido: $telefone');
      print('Senha recebida: $senha');

      isLoading = true;
      errorMessage = '';

      final usuarioModel = UsuarioModel(
        base: BaseModel.novo(),
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
      );

      print('UsuarioModel criado: ${usuarioModel.nome}, ${usuarioModel.email}');
      print('Base ID: ${usuarioModel.base.id}');

      final savedUser = await _service.saveOrUpdate(usuarioModel);
      print('✅ Service.saveOrUpdate chamado com sucesso');

      await loadCurrentUser();
      print('✅ loadCurrentUser chamado com sucesso');

      return true;
    } catch (e) {
      print('❌ ERRO no UsuarioController.saveUserFromRegistration: $e');
      errorMessage = 'Erro ao salvar usuário: ${e.toString()}';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateUser() async {
    try {
      isLoading = true;
      errorMessage = '';

      print('=== ATUALIZANDO USUÁRIO ===');
      print('Dados: ${usuario.nome} - ${usuario.email} - ${usuario.telefone}');

      final updatedUser = await _service.saveOrUpdate(usuario.toModel());
      print('✅ Usuário atualizado com sucesso');

      await loadCurrentUser();
      return true;
    } catch (e) {
      if (e.toString().contains('Um email de verificação foi enviado')) {
        print('📧 Email de verificação enviado');
        await loadCurrentUser();
        rethrow;
      }

      errorMessage = 'Erro ao atualizar usuário: ${e.toString()}';
      print('❌ $errorMessage');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updatePassword(String senhaAtual, String novaSenha) async {
    try {
      isLoading = true;
      errorMessage = '';

      print('=== ATUALIZANDO SENHA ===');

      await _service.updatePassword(senhaAtual, novaSenha);

      usuario.senha = novaSenha;
      await _service.saveOrUpdate(usuario.toModel());

      print('✅ Senha atualizada com sucesso');
      return true;
    } catch (e) {
      errorMessage = 'Erro ao atualizar senha: ${e.toString()}';
      print('❌ $errorMessage');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteUser() async {
    try {
      isLoading = true;
      errorMessage = '';

      print('=== EXCLUINDO USUÁRIO ===');

      await _service.deleteAccount();

      usuario = UsuarioStoreFactory.novo();

      print('✅ Usuário excluído com sucesso');
      return true;
    } catch (e) {
      errorMessage = 'Erro ao excluir usuário: ${e.toString()}';
      print('❌ $errorMessage');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    errorMessage = '';
  }

  @computed
  bool get hasError => errorMessage.isNotEmpty;

  @computed
  bool get isFormValid => usuario.isValid;
}
