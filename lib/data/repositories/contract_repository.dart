import '../datasources/local/contract_local_datasource.dart';
import '../models/contract_model.dart';

/// Repository for contract operations
class ContractRepository {
  final ContractLocalDatasource _datasource = ContractLocalDatasource();

  Future<int> createContract(ContractModel contract) async {
    return await _datasource.insertContract(contract);
  }

  Future<ContractModel?> getContractByRentalId(int rentalId) async {
    return await _datasource.getContractByRentalId(rentalId);
  }

  Future<int> updateRenterSignature(int rentalId, String path) async {
    return await _datasource.updateRenterSignature(rentalId, path);
  }

  Future<int> updateOwnerSignature(int rentalId, String path) async {
    return await _datasource.updateOwnerSignature(rentalId, path);
  }

  /// Generate unique contract number
  String generateContractNumber() {
    final now = DateTime.now();
    final ts = now.millisecondsSinceEpoch.toString();
    return 'KTR-${ts.substring(ts.length - 8)}';
  }
}
