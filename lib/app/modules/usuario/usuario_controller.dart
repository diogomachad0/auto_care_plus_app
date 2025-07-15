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

      final currentUser = await _service.getCurrentUser();
      if (currentUser != null) {
        usuario = UsuarioStoreFactory.fromModel(currentUser);
      } else {}
    } catch (e) {
      errorMessage = 'Erro ao carregar dados do usuário: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> saveUserFromRegistration(String nome, String email, String telefone, String senha) async {
    try {
      isLoading = true;
      errorMessage = '';

      final usuarioModel = UsuarioModel(
        base: BaseModel.novo(),
        nome: nome,
        email: email,
        telefone: telefone,
        senha: senha,
      );

      final savedUser = await _service.saveOrUpdate(usuarioModel);

      await loadCurrentUser();
      return true;
    } catch (e) {
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

      final updatedUser = await _service.saveOrUpdate(usuario.toModel());

      await loadCurrentUser();
      return true;
    } catch (e) {
      if (e.toString().contains('Um email de verificação foi enviado')) {
        await loadCurrentUser();
        rethrow;
      }

      errorMessage = 'Erro ao atualizar usuário: ${e.toString()}';
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

      await _service.updatePassword(senhaAtual, novaSenha);

      usuario.senha = novaSenha;
      await _service.saveOrUpdate(usuario.toModel());

      return true;
    } catch (e) {
      errorMessage = 'Erro ao atualizar senha: ${e.toString()}';
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

      await _service.deleteAccount();

      usuario = UsuarioStoreFactory.novo();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao excluir usuário: ${e.toString()}';
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
