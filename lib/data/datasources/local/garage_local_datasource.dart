import '../../models/garage_model.dart';
import 'database_helper.dart';

/// Local datasource for garage CRUD operations
class GarageLocalDatasource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertGarage(GarageModel garage) async {
    final db = await _dbHelper.database;
    int garageId = 0;
    await db.transaction((txn) async {
      garageId = await txn.insert('garages', garage.toMap());
      for (final f in garage.facilities) {
        await txn.insert('garage_facilities', {
          'garage_id': garageId,
          'name': f,
        });
      }
    });
    return garageId;
  }

  Future<int> updateGarage(GarageModel garage) async {
    final db = await _dbHelper.database;
    final map = garage.toMap();
    map['updated_at'] = DateTime.now().toIso8601String();
    map.remove('id');

    int result = 0;
    await db.transaction((txn) async {
      result = await txn.update(
        'garages',
        map,
        where: 'id = ?',
        whereArgs: [garage.id],
      );
      await txn.delete('garage_facilities',
          where: 'garage_id = ?', whereArgs: [garage.id]);
      for (final f in garage.facilities) {
        await txn.insert('garage_facilities', {
          'garage_id': garage.id,
          'name': f,
        });
      }
    });
    return result;
  }

  Future<int> deleteGarage(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('garages', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> _getFacilities(int garageId) async {
    final db = await _dbHelper.database;
    final result = await db.query('garage_facilities',
        where: 'garage_id = ?', whereArgs: [garageId]);
    return result.map((r) => r['name'] as String).toList();
  }

  Future<GarageModel?> getGarageById(int id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('garages', where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) return null;
    final facilities = await _getFacilities(id);
    return GarageModel.fromMap(result.first, facilities: facilities);
  }

  Future<List<GarageModel>> getAllGarages() async {
    final db = await _dbHelper.database;
    final result = await db.query('garages', orderBy: 'created_at DESC');
    final garages = <GarageModel>[];
    for (final row in result) {
      final facilities = await _getFacilities(row['id'] as int);
      garages.add(GarageModel.fromMap(row, facilities: facilities));
    }
    return garages;
  }

  Future<List<GarageModel>> getAvailableGarages() async {
    final db = await _dbHelper.database;
    final result = await db.query('garages',
        where: 'status = ?',
        whereArgs: ['available'],
        orderBy: 'created_at DESC');
    final garages = <GarageModel>[];
    for (final row in result) {
      final facilities = await _getFacilities(row['id'] as int);
      garages.add(GarageModel.fromMap(row, facilities: facilities));
    }
    return garages;
  }

  Future<List<GarageModel>> getGaragesByOwner(int ownerId) async {
    final db = await _dbHelper.database;
    final result = await db.query('garages',
        where: 'owner_id = ?',
        whereArgs: [ownerId],
        orderBy: 'created_at DESC');
    final garages = <GarageModel>[];
    for (final row in result) {
      final facilities = await _getFacilities(row['id'] as int);
      garages.add(GarageModel.fromMap(row, facilities: facilities));
    }
    return garages;
  }

  Future<List<GarageModel>> searchGarages(String keyword) async {
    final db = await _dbHelper.database;
    final kw = '%$keyword%';
    final result = await db.query('garages',
        where: 'name LIKE ? OR address LIKE ? OR city LIKE ?',
        whereArgs: [kw, kw, kw],
        orderBy: 'created_at DESC');
    final garages = <GarageModel>[];
    for (final row in result) {
      final facilities = await _getFacilities(row['id'] as int);
      garages.add(GarageModel.fromMap(row, facilities: facilities));
    }
    return garages;
  }

  Future<List<GarageModel>> filterByPrice({int? minPrice, int? maxPrice}) async {
    final db = await _dbHelper.database;
    String where = '1=1';
    final args = <dynamic>[];
    if (minPrice != null) {
      where += ' AND price_per_month >= ?';
      args.add(minPrice);
    }
    if (maxPrice != null) {
      where += ' AND price_per_month <= ?';
      args.add(maxPrice);
    }
    final result = await db.query('garages',
        where: where, whereArgs: args, orderBy: 'price_per_month ASC');
    final garages = <GarageModel>[];
    for (final row in result) {
      final facilities = await _getFacilities(row['id'] as int);
      garages.add(GarageModel.fromMap(row, facilities: facilities));
    }
    return garages;
  }

  Future<int> updateGarageStatus(int id, String status) async {
    final db = await _dbHelper.database;
    return await db.update(
      'garages',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
