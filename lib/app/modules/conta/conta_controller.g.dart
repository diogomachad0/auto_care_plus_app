// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conta_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContaController on _ContaControllerBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_ContaControllerBase.hasError'))
          .value;
  Computed<bool>? _$hasSuccessComputed;

  @override
  bool get hasSuccess =>
      (_$hasSuccessComputed ??= Computed<bool>(() => super.hasSuccess,
              name: '_ContaControllerBase.hasSuccess'))
          .value;
  Computed<bool>? _$isProfileFormValidComputed;

  @override
  bool get isProfileFormValid => (_$isProfileFormValidComputed ??=
          Computed<bool>(() => super.isProfileFormValid,
              name: '_ContaControllerBase.isProfileFormValid'))
      .value;
  Computed<bool>? _$isPasswordFormValidComputed;

  @override
  bool get isPasswordFormValid => (_$isPasswordFormValidComputed ??=
          Computed<bool>(() => super.isPasswordFormValid,
              name: '_ContaControllerBase.isPasswordFormValid'))
      .value;
  Computed<bool>? _$emailWasChangedComputed;

  @override
  bool get emailWasChanged =>
      (_$emailWasChangedComputed ??= Computed<bool>(() => super.emailWasChanged,
              name: '_ContaControllerBase.emailWasChanged'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: '_ContaControllerBase.isLoading', context: context);

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
      Atom(name: '_ContaControllerBase.errorMessage', context: context);

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

  late final _$successMessageAtom =
      Atom(name: '_ContaControllerBase.successMessage', context: context);

  @override
  String get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$_originalEmailAtom =
      Atom(name: '_ContaControllerBase._originalEmail', context: context);

  @override
  String get _originalEmail {
    _$_originalEmailAtom.reportRead();
    return super._originalEmail;
  }

  @override
  set _originalEmail(String value) {
    _$_originalEmailAtom.reportWrite(value, super._originalEmail, () {
      super._originalEmail = value;
    });
  }

  late final _$showEmailPasswordDialogAtom = Atom(
      name: '_ContaControllerBase.showEmailPasswordDialog', context: context);

  @override
  bool get showEmailPasswordDialog {
    _$showEmailPasswordDialogAtom.reportRead();
    return super.showEmailPasswordDialog;
  }

  @override
  set showEmailPasswordDialog(bool value) {
    _$showEmailPasswordDialogAtom
        .reportWrite(value, super.showEmailPasswordDialog, () {
      super.showEmailPasswordDialog = value;
    });
  }

  late final _$loadUserDataAsyncAction =
      AsyncAction('_ContaControllerBase.loadUserData', context: context);

  @override
  Future<void> loadUserData() {
    return _$loadUserDataAsyncAction.run(() => super.loadUserData());
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_ContaControllerBase.updateProfile', context: context);

  @override
  Future<bool> updateProfile() {
    return _$updateProfileAsyncAction.run(() => super.updateProfile());
  }

  late final _$updatePasswordAsyncAction =
      AsyncAction('_ContaControllerBase.updatePassword', context: context);

  @override
  Future<bool> updatePassword() {
    return _$updatePasswordAsyncAction.run(() => super.updatePassword());
  }

  late final _$deleteAccountAsyncAction =
      AsyncAction('_ContaControllerBase.deleteAccount', context: context);

  @override
  Future<bool> deleteAccount() {
    return _$deleteAccountAsyncAction.run(() => super.deleteAccount());
  }

  late final _$_ContaControllerBaseActionController =
      ActionController(name: '_ContaControllerBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_ContaControllerBaseActionController.startAction(
        name: '_ContaControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ContaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSuccess() {
    final _$actionInfo = _$_ContaControllerBaseActionController.startAction(
        name: '_ContaControllerBase.clearSuccess');
    try {
      return super.clearSuccess();
    } finally {
      _$_ContaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearEmailPasswordDialog() {
    final _$actionInfo = _$_ContaControllerBaseActionController.startAction(
        name: '_ContaControllerBase.clearEmailPasswordDialog');
    try {
      return super.clearEmailPasswordDialog();
    } finally {
      _$_ContaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
showEmailPasswordDialog: ${showEmailPasswordDialog},
hasError: ${hasError},
hasSuccess: ${hasSuccess},
isProfileFormValid: ${isProfileFormValid},
isPasswordFormValid: ${isPasswordFormValid},
emailWasChanged: ${emailWasChanged}
    ''';
  }
}
