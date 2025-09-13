
import 'package:compra_certa/data/services/selic_database_service.dart';

abstract class SelicRepository {
  Future<void> saveSelicRate(double rate);
  Future<double?> getSelicRate();
}

class SelicRepositoryImpl implements SelicRepository {
  final SelicDatabaseService _databaseService;

  SelicRepositoryImpl(this._databaseService);

  @override
  Future<void> saveSelicRate(double rate) {
    return _databaseService.saveSelicRate(rate);
  }

  @override
  Future<double?> getSelicRate() {
    return _databaseService.getSelicRate();
  }
}
