import '../../models/contract_model.dart';
import 'database_helper.dart';

/// Local datasource for contract CRUD operations
class ContractLocalDatasource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertContract(ContractModel contract) async {
    final db = await _dbHelper.database;
    return await db.insert('contracts', contract.toMap());
  }

  Future<ContractModel?> getContractByRentalId(int rentalId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'contracts',
      where: 'rental_id = ?',
      whereArgs: [rentalId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ContractModel.fromMap(result.first);
  }

  Future<int> updateRenterSignature(int rentalId, String path) async {
    final db = await _dbHelper.database;
    return await db.update(
      'contracts',
      {'renter_signature_path': path},
      where: 'rental_id = ?',
      whereArgs: [rentalId],
    );
  }

  Future<int> updateOwnerSignature(int rentalId, String path) async {
    final db = await _dbHelper.database;
    return await db.update(
      'contracts',
      {'owner_signature_path': path},
      where: 'rental_id = ?',
      whereArgs: [rentalId],
    );
  }
}
