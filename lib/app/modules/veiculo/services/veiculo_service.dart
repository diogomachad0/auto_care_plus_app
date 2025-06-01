import 'package:auto_care_plus_app/app/modules/veiculo/models/veiculo_model.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/shared/services/service/service.dart';

class VeiculoService extends BaseService<VeiculoModel, IVeiculoRepository> implements IVeiculoService {
  VeiculoService(super.repository);
}
