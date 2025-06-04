import 'package:auto_care_plus_app/app/modules/atividade/models/atividade_model.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service.dart';

class AtividadeService extends BaseService<AtividadeModel, IAtividadeRepository> implements IAtividadeService {
  AtividadeService(super.repository);
}