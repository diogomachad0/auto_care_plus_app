import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/repository_interface.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service_interface.dart';

class BaseService<T extends IBaseModel, Y extends IRepository<T>>
    implements IService<T> {
  final Y repository;

  BaseService(this.repository);

  @override
  Future<T> saveOrUpdate(T entity, {String? uri}) async {
    if (entity.base.isNew) {
      entity.base.setDataHoraCriado();

      await repository.save(entity);
    } else {
      await repository.update(entity);
    }

    return entity;
  }

  @override
  Future<T?> getFirst() async => await repository.getFirst();

  @override
  Future<List<T>> getAll() async => await repository.getAll();

  @override
  Future<T?> getById(String id, {bool deleted = false}) async {
    return await repository.getById(id, deleted: deleted);
  }

  @override
  Future<void> delete(T? entity, {String? uri}) async {
    entity!.base.dataHoraDeletado = DateTime.now();
    await repository.delete(entity);
  }
}
