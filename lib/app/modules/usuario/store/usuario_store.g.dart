// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioStore on _UsuarioStoreBase, Store {
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(() => super.isValid,
          name: '_UsuarioStoreBase.isValid'))
      .value;
  Computed<String>? _$telefoneFormatadoComputed;

  @override
  String get telefoneFormatado => (_$telefoneFormatadoComputed ??=
          Computed<String>(() => super.telefoneFormatado,
              name: '_UsuarioStoreBase.telefoneFormatado'))
      .value;

  late final _$baseAtom =
      Atom(name: '_UsuarioStoreBase.base', context: context);

  @override
  BaseStore get base {
    _$baseAtom.reportRead();
    return super.base;
  }

  @override
  set base(BaseStore value) {
    _$baseAtom.reportWrite(value, super.base, () {
      super.base = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: '_UsuarioStoreBase.nome', context: context);

  @override
  String get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_UsuarioStoreBase.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$telefoneAtom =
      Atom(name: '_UsuarioStoreBase.telefone', context: context);

  @override
  String get telefone {
    _$telefoneAtom.reportRead();
    return super.telefone;
  }

  @override
  set telefone(String value) {
    _$telefoneAtom.reportWrite(value, super.telefone, () {
      super.telefone = value;
    });
  }

  late final _$senhaAtom =
      Atom(name: '_UsuarioStoreBase.senha', context: context);

  @override
  String get senha {
    _$senhaAtom.reportRead();
    return super.senha;
  }

  @override
  set senha(String value) {
    _$senhaAtom.reportWrite(value, super.senha, () {
      super.senha = value;
    });
  }

  @override
  String toString() {
    return '''
base: ${base},
nome: ${nome},
email: ${email},
telefone: ${telefone},
senha: ${senha},
isValid: ${isValid},
telefoneFormatado: ${telefoneFormatado}
    ''';
  }
}
