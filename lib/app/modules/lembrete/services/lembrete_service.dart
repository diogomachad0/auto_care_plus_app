import 'package:auto_care_plus_app/app/modules/lembrete/models/lembrete_model.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/repositories/lembrete_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/services/lembrete_service_interface.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service.dart';

class LembreteService extends BaseService<LembreteModel, ILembreteRepository> implements ILembreteService {
  LembreteService(super.repository);
}
