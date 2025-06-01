// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lembrete_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LembreteController on _LembreteControllerBase, Store {
  late final _$searchTextAtom =
      Atom(name: '_LembreteControllerBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  late final _$lembreteAtom =
      Atom(name: '_LembreteControllerBase.lembrete', context: context);

  @override
  LembreteStore get lembrete {
    _$lembreteAtom.reportRead();
    return super.lembrete;
  }

  @override
  set lembrete(LembreteStore value) {
    _$lembreteAtom.reportWrite(value, super.lembrete, () {
      super.lembrete = value;
    });
  }

  late final _$lembretesAtom =
      Atom(name: '_LembreteControllerBase.lembretes', context: context);

  @override
  ObservableList<LembreteStore> get lembretes {
    _$lembretesAtom.reportRead();
    return super.lembretes;
  }

  @override
  set lembretes(ObservableList<LembreteStore> value) {
    _$lembretesAtom.reportWrite(value, super.lembretes, () {
      super.lembretes = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_LembreteControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_LembreteControllerBaseActionController =
      ActionController(name: '_LembreteControllerBase', context: context);

  @override
  void updateLembrete(String titulo, DateTime data, bool notificar) {
    final _$actionInfo = _$_LembreteControllerBaseActionController.startAction(
        name: '_LembreteControllerBase.updateLembrete');
    try {
      return super.updateLembrete(titulo, data, notificar);
    } finally {
      _$_LembreteControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
lembrete: ${lembrete},
lembretes: ${lembretes}
    ''';
  }
}
