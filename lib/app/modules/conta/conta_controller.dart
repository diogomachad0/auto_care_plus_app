import 'package:auto_care_plus_app/app/modules/usuario/services/usuario_services_interface.dart';
import 'package:auto_care_plus_app/app/modules/usuario/store/usuario_store.dart';
import 'package:auto_care_plus_app/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'conta_controller.g.dart';

class ContaController = _ContaControllerBase with _$ContaController;

abstract class _ContaControllerBase with Store {
  final UsuarioController _usuarioController = Modular.get<UsuarioController>();
  final IUsuarioService _usuarioService = Modular.get<IUsuarioService>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaAtualController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @observable
  String successMessage = '';

  @observable
  String _originalEmail = '';

  @observable
  bool showEmailPasswordDialog = false;

  @action
  Future<void> loadUserData() async {
    try {
      isLoading = true;
      errorMessage = '';

      await _usuarioController.loadCurrentUser();
      _updateControllers();
    } catch (e) {
      errorMessage = 'Erro ao carregar dados do usuário: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  void _updateControllers() {
    final usuario = _usuarioController.usuario;
    nomeController.text = usuario.nome;
    emailController.text = usuario.email;
    telefoneController.text = usuario.telefoneFormatado;
    _originalEmail = usuario.email;
  }

  @action
  Future<bool> updateProfile() async {
    try {
      isLoading = true;
      errorMessage = '';
      successMessage = '';

      final emailChanged = emailController.text.trim() != _originalEmail;
      final nomeChanged = nomeController.text.trim() != _usuarioController.usuario.nome;
      final telefoneChanged = telefoneController.text.replaceAll(RegExp(r'[^\d]'), '') != _usuarioController.usuario.telefone;

      if (emailChanged && senhaAtualController.text.isEmpty) {
        showEmailPasswordDialog = true;
        return false;
      }

      if (emailChanged) {
        try {
          await _usuarioService.validateCurrentPassword(senhaAtualController.text);
        } catch (e) {
          errorMessage = 'Senha atual incorreta';
          return false;
        }
      }

      _usuarioController.usuario.nome = nomeController.text.trim();
      _usuarioController.usuario.email = emailController.text.trim();
      _usuarioController.usuario.telefone = telefoneController.text.replaceAll(RegExp(r'[^\d]'), '');

      final success = await _usuarioController.updateUser();

      if (success) {
        if (emailChanged) {
          senhaAtualController.clear();
          successMessage = 'Perfil atualizado! Um email de verificação foi enviado para ${emailController.text.trim()}';
        } else if (nomeChanged || telefoneChanged) {
          successMessage = 'Dados pessoais atualizados com sucesso!';
        } else {
          successMessage = 'Perfil atualizado com sucesso!';
        }

        await loadUserData();
      } else {
        errorMessage = _usuarioController.errorMessage;
      }

      return success;
    } catch (e) {
      if (e.toString().contains('Um email de verificação foi enviado')) {
        successMessage = e.toString().replaceAll('Exception: ', '');
        senhaAtualController.clear();
        await loadUserData();
        return true;
      }

      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updatePassword() async {
    try {
      isLoading = true;
      errorMessage = '';
      successMessage = '';

      if (novaSenhaController.text != confirmarSenhaController.text) {
        errorMessage = 'As senhas não coincidem';
        return false;
      }

      if (novaSenhaController.text.length < 6) {
        errorMessage = 'A nova senha deve ter pelo menos 6 caracteres';
        return false;
      }


      await _usuarioService.updatePassword(
        senhaAtualController.text,
        novaSenhaController.text,
      );

      _usuarioController.usuario.senha = novaSenhaController.text;
      await _usuarioController.updateUser();

      senhaAtualController.clear();
      novaSenhaController.clear();
      confirmarSenhaController.clear();

      successMessage = 'Senha alterada com sucesso!';
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteAccount() async {
    try {
      isLoading = true;
      errorMessage = '';


      await _usuarioService.deleteAccount();
      _usuarioController.usuario = UsuarioStoreFactory.novo();

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    errorMessage = '';
  }

  @action
  void clearSuccess() {
    successMessage = '';
  }

  @action
  void clearEmailPasswordDialog() {
    showEmailPasswordDialog = false;
  }

  @computed
  bool get hasError => errorMessage.isNotEmpty;

  @computed
  bool get hasSuccess => successMessage.isNotEmpty;

  @computed
  bool get isProfileFormValid {
    return nomeController.text.isNotEmpty && emailController.text.isNotEmpty && telefoneController.text.isNotEmpty;
  }

  @computed
  bool get isPasswordFormValid {
    return senhaAtualController.text.isNotEmpty && novaSenhaController.text.isNotEmpty && confirmarSenhaController.text.isNotEmpty;
  }

  @computed
  bool get emailWasChanged {
    return emailController.text.trim() != _originalEmail;
  }

  String? validateNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    final names = value.trim().split(' ');
    if (names.length < 2) {
      return 'Digite nome e sobrenome';
    }

    for (String name in names) {
      if (name.isEmpty) continue;
      if (name[0] != name[0].toUpperCase()) {
        return 'Cada nome deve começar com letra maiúscula';
      }
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    if (value[0] != value[0].toLowerCase()) {
      return 'E-mail não deve começar com letra maiúscula';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um e-mail válido';
    }

    return null;
  }

  String? validateTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (numbersOnly.length != 11) {
      return 'Telefone deve ter 11 dígitos';
    }

    final areaCode = int.tryParse(numbersOnly.substring(0, 2));
    if (areaCode == null || areaCode < 11 || areaCode > 99) {
      return 'Código de área inválido';
    }

    if (numbersOnly[2] != '9') {
      return 'Número deve ser de celular (9º dígito deve ser 9)';
    }

    return null;
  }

  String formatPhone(String value) {
    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (numbersOnly.length <= 2) {
      return numbersOnly;
    } else if (numbersOnly.length <= 7) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2)}';
    } else if (numbersOnly.length <= 11) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 7)}-${numbersOnly.substring(7)}';
    } else {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 7)}-${numbersOnly.substring(7, 11)}';
    }
  }

  String formatName(String value) {
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaAtualController.dispose();
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
  }
}
