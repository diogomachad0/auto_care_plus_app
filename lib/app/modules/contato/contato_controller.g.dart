// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contato_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContatoController on _ContatoControllerBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_ContatoControllerBase.hasError'))
          .value;
  Computed<bool>? _$hasSuccessComputed;

  @override
  bool get hasSuccess =>
      (_$hasSuccessComputed ??= Computed<bool>(() => super.hasSuccess,
              name: '_ContatoControllerBase.hasSuccess'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_ContatoControllerBase.isFormValid'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: '_ContatoControllerBase.isLoading', context: context);

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
      Atom(name: '_ContatoControllerBase.errorMessage', context: context);

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
      Atom(name: '_ContatoControllerBase.successMessage', context: context);

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

  late final _$enviarContatoAsyncAction =
      AsyncAction('_ContatoControllerBase.enviarContato', context: context);

  @override
  Future<bool> enviarContato() {
    return _$enviarContatoAsyncAction.run(() => super.enviarContato());
  }

  late final _$_ContatoControllerBaseActionController =
      ActionController(name: '_ContatoControllerBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_ContatoControllerBaseActionController.startAction(
        name: '_ContatoControllerBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ContatoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSuccess() {
    final _$actionInfo = _$_ContatoControllerBaseActionController.startAction(
        name: '_ContatoControllerBase.clearSuccess');
    try {
      return super.clearSuccess();
    } finally {
      _$_ContatoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
hasError: ${hasError},
hasSuccess: ${hasSuccess},
isFormValid: ${isFormValid}
    ''';
  }
}
