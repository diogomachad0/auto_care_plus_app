import 'package:auto_care_plus_app/app/modules/usuario/models/usuario_model.dart';
import 'package:auto_care_plus_app/app/shared/stores/base_store.dart';
import 'package:mobx/mobx.dart';

part 'usuario_store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class UsuarioStoreFactory {
  static UsuarioStore fromModel(UsuarioModel model) => UsuarioStore(
        base: BaseStoreFactory.fromEntity(model.base),
        nome: model.nome,
        email: model.email,
        telefone: model.telefone,
        senha: model.senha,
      );

  static UsuarioStore novo() => UsuarioStore(
        base: BaseStoreFactory.novo(),
        nome: '',
        email: '',
        telefone: '',
        senha: '',
      );
}

abstract class _UsuarioStoreBase with Store {
  @observable
  BaseStore base;

  @observable
  String nome;

  @observable
  String email;

  @observable
  String telefone;

  @observable
  String senha;

  _UsuarioStoreBase({
    required this.base,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  UsuarioModel toModel() {
    return UsuarioModel(
      base: base.toModel(),
      nome: nome,
      email: email,
      telefone: telefone,
      senha: senha,
    );
  }

  @computed
  bool get isValid {
    return nome.isNotEmpty && email.isNotEmpty && telefone.isNotEmpty && senha.isNotEmpty;
  }

  @computed
  String get telefoneFormatado {
    final numbersOnly = telefone.replaceAll(RegExp(r'[^\d]'), '');

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
}
