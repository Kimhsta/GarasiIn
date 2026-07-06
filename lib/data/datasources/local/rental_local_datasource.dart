import '../../models/rental_model.dart';
import 'database_helper.dart';

/// Local datasource for rental CRUD operations
class RentalLocalDatasource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertRental(RentalModel rental) async {
    final db = await _dbHelper.database;
    return await db.insert('rentals', rental.toMap());
  }

  Future<RentalModel?> getRentalById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT r.*, g.name as garage_name, g.address as garage_address, 
             u.name as renter_name
      FROM rentals r
      LEFT JOIN garages g ON r.garage_id = g.id
      LEFT JOIN users u ON r.renter_id = u.id
      WHERE r.id = ?
      LIMIT 1
    ''', [id]);
    if (result.isEmpty) return null;
    return RentalModel.fromMap(result.first);
  }

  Future<List<RentalModel>> getRentalsByRenter(int renterId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT r.*, g.name as garage_name, g.address as garage_address,
             u.name as renter_name
      FROM rentals r
      LEFT JOIN garages g ON r.garage_id = g.id
      LEFT JOIN users u ON r.renter_id = u.id
      WHERE r.renter_id = ?
      ORDER BY r.created_at DESC
    ''', [renterId]);
    return result.map((r) => RentalModel.fromMap(r)).toList();
  }

  Future<List<RentalModel>> getRentalsByOwner(int ownerId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT r.*, g.name as garage_name, g.address as garage_address,
             u.name as renter_name
      FROM rentals r
      LEFT JOIN garages g ON r.garage_id = g.id
      LEFT JOIN users u ON r.renter_id = u.id
      WHERE r.owner_id = ?
      ORDER BY r.created_at DESC
    ''', [ownerId]);
    return result.map((r) => RentalModel.fromMap(r)).toList();
  }

  Future<int> updateRentalStatus(int id, String status) async {
    final db = await _dbHelper.database;
    return await db.update(
      'rentals',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
