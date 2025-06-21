// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioController on _UsuarioControllerBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_UsuarioControllerBase.hasError'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_UsuarioControllerBase.isFormValid'))
          .value;

  late final _$usuarioAtom =
      Atom(name: '_UsuarioControllerBase.usuario', context: context);

  @override
  UsuarioStore get usuario {
    _$usuarioAtom.reportRead();
    return super.usuario;
  }

  @override
  set usuario(UsuarioStore value) {
    _$usuarioAtom.reportWrite(value, super.usuario, () {
      super.usuario = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_UsuarioControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_UsuarioControllerBase.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadCurrentUserAsyncAction =
      AsyncAction('_UsuarioControllerBase.loadCurrentUser', context: context);

  @override
  Future<void> loadCurrentUser() {
    return _$loadCurrentUserAsyncAction.run(() => super.loadCurrentUser());
  }

  late final _$saveUserFromRegistrationAsyncAction = AsyncAction(
      '_UsuarioControllerBase.saveUserFromRegistration',
      context: context);

  @override
  Future<bool> saveUserFromRegistration(
      String nome, String email, String telefone, String senha) {
    return _$saveUserFromRegistrationAsyncAction.run(
        () => super.saveUserFromRegistration(nome, email, telefone, senha));
  }

  late final _$updateUserAsyncAction =
      AsyncAction('_UsuarioControllerBase.updateUser', context: context);

  @override
  Future<bool> updateUser() {
    return _$updateUserAsyncAction.run(() => super.updateUser());
  }

  late final _$updatePasswordAsyncAction =
      AsyncAction('_UsuarioControllerBase.updatePassword', context: context);

  @override
  Future<bool> updatePassword(String senhaAtual, String novaSenha) {
    return _$updatePasswordAsyncAction
        .run(() => super.updatePassword(senhaAtual, novaSenha));
  }

  late final _$deleteUserAsyncAction =
      AsyncAction('_UsuarioControllerBase.deleteUser', context: context);

  @override
  Future<bool> deleteUser() {
    return _$deleteUserAsyncAction.run(() => super.deleteUser());
  }

  late final _$_UsuarioControllerBaseActionController =
      ActionController(name: '_UsuarioControllerBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_UsuarioControllerBaseActionController.startAction(
        name: '_UsuarioControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_UsuarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
usuario: ${usuario},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasError: ${hasError},
isFormValid: ${isFormValid}
    ''';
  }
}
