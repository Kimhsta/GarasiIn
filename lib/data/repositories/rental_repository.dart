import '../datasources/local/rental_local_datasource.dart';
import '../datasources/local/database_helper.dart';
import '../models/rental_model.dart';
import '../../core/utils/app_constants.dart';

/// Repository for rental/booking operations
class RentalRepository {
  final RentalLocalDatasource _datasource = RentalLocalDatasource();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createRental(RentalModel rental) async {
    return await _datasource.insertRental(rental);
  }

  Future<List<RentalModel>> getRentalsByRenter(int renterId) async {
    return await _datasource.getRentalsByRenter(renterId);
  }

  Future<List<RentalModel>> getRentalsByOwner(int ownerId) async {
    return await _datasource.getRentalsByOwner(ownerId);
  }

  Future<RentalModel?> getRentalById(int id) async {
    return await _datasource.getRentalById(id);
  }

  Future<int> updateRentalStatus(int id, String status) async {
    return await _datasource.updateRentalStatus(id, status);
  }

  Future<int> approveRental(int rentalId) async {
    final rental = await _datasource.getRentalById(rentalId);
    if (rental == null) return 0;

    final db = await _dbHelper.database;
    int result = 0;
    await db.transaction((txn) async {
      // Update rental status
      result = await txn.update(
        'rentals',
        {
          'status': AppConstants.rentalAccepted,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [rentalId],
      );

      // Update garage status to rented
      await txn.update(
        'garages',
        {
          'status': AppConstants.statusRented,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [rental.garageId],
      );
    });

    return result;
  }

  Future<int> rejectRental(int rentalId) async {
    return await _datasource.updateRentalStatus(
        rentalId, AppConstants.rentalRejected);
  }

  Future<int> cancelRental(int rentalId) async {
    return await _datasource.updateRentalStatus(
        rentalId, AppConstants.rentalCancelled);
  }
}
