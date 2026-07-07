import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:garasin/data/datasources/local/database_helper.dart';
import 'package:garasin/data/models/garage_model.dart';
import 'package:garasin/data/models/rental_model.dart';
import 'package:garasin/data/models/contract_model.dart';
import 'package:garasin/data/repositories/user_repository.dart';
import 'package:garasin/data/repositories/garage_repository.dart';
import 'package:garasin/data/repositories/rental_repository.dart';
import 'package:garasin/data/repositories/contract_repository.dart';
import 'package:garasin/core/utils/password_helper.dart';

void main() {
  // Initialize FFI for sqflite testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late UserRepository userRepo;
  late GarageRepository garageRepo;
  late RentalRepository rentalRepo;
  late ContractRepository contractRepo;

  setUpAll(() async {
    // Use in-memory database for testing
    final db = await databaseFactoryFfi.openDatabase(
      ':memory:',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // Create tables
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              phone TEXT NOT NULL,
              password TEXT NOT NULL,
              role TEXT NOT NULL CHECK(role IN ('owner', 'renter')),
              image_path TEXT,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP,
              updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
          ''');

          await db.execute('''
            CREATE TABLE garages (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              owner_id INTEGER NOT NULL,
              name TEXT NOT NULL,
              address TEXT NOT NULL,
              city TEXT DEFAULT 'Solo',
              length REAL NOT NULL,
              width REAL NOT NULL,
              price_per_month INTEGER NOT NULL,
              status TEXT NOT NULL DEFAULT 'available' CHECK(status IN ('available', 'rented')),
              road_access TEXT NOT NULL,
              description TEXT,
              image_path TEXT,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP,
              updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY(owner_id) REFERENCES users(id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE garage_facilities (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              garage_id INTEGER NOT NULL,
              name TEXT NOT NULL,
              FOREIGN KEY(garage_id) REFERENCES garages(id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE rentals (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              garage_id INTEGER NOT NULL,
              renter_id INTEGER NOT NULL,
              owner_id INTEGER NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              total_price INTEGER NOT NULL,
              status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'accepted', 'rejected', 'cancelled')),
              note TEXT,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP,
              updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY(garage_id) REFERENCES garages(id),
              FOREIGN KEY(renter_id) REFERENCES users(id),
              FOREIGN KEY(owner_id) REFERENCES users(id)
            )
          ''');

          await db.execute('''
            CREATE TABLE contracts (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              rental_id INTEGER NOT NULL UNIQUE,
              contract_number TEXT NOT NULL UNIQUE,
              owner_name TEXT NOT NULL,
              owner_email TEXT NOT NULL,
              owner_phone TEXT NOT NULL,
              renter_name TEXT NOT NULL,
              renter_email TEXT NOT NULL,
              renter_phone TEXT NOT NULL,
              garage_name TEXT NOT NULL,
              garage_address TEXT NOT NULL,
              start_date TEXT NOT NULL,
              end_date TEXT NOT NULL,
              total_price INTEGER NOT NULL,
              note TEXT,
              renter_signature_path TEXT,
              owner_signature_path TEXT,
              terms_text TEXT NOT NULL,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY(rental_id) REFERENCES rentals(id) ON DELETE CASCADE
            )
          ''');
        },
      ),
    );

    // Override the singleton database for testing
    DatabaseHelper.testDatabase = db;

    userRepo = UserRepository();
    garageRepo = GarageRepository();
    rentalRepo = RentalRepository();
    contractRepo = ContractRepository();
  });

  // ═══════════════════════════════════════════════════════════════════
  // USER CRUD TESTS
  // ═══════════════════════════════════════════════════════════════════
  group('USER CRUD', () {
    test('CREATE - Register new owner', () async {
      final user = await userRepo.register(
        name: 'Budi Santoso',
        email: 'budi@test.com',
        phone: '081234567890',
        password: '123456',
        role: 'owner',
      );
      expect(user.id, isNotNull);
      expect(user.name, 'Budi Santoso');
      expect(user.email, 'budi@test.com');
      expect(user.role, 'owner');
    });

    test('CREATE - Register new renter', () async {
      final user = await userRepo.register(
        name: 'Andi Pratama',
        email: 'andi@test.com',
        phone: '085678901234',
        password: '123456',
        role: 'renter',
      );
      expect(user.id, isNotNull);
      expect(user.name, 'Andi Pratama');
      expect(user.role, 'renter');
    });

    test('READ - Get user by ID', () async {
      final user = await userRepo.getUserById(1);
      expect(user, isNotNull);
      expect(user!.name, 'Budi Santoso');
      expect(user.email, 'budi@test.com');
    });

    test('READ - Get user by email', () async {
      final user = await userRepo.getUserByEmail('andi@test.com');
      expect(user, isNotNull);
      expect(user!.name, 'Andi Pratama');
    });

    test('READ - Login with correct credentials', () async {
      final user = await userRepo.login('budi@test.com', '123456');
      expect(user, isNotNull);
      expect(user!.email, 'budi@test.com');
    });

    test('READ - Login with wrong password returns null', () async {
      final user = await userRepo.login('budi@test.com', 'wrongpass');
      expect(user, isNull);
    });

    test('READ - Login with non-existent email returns null', () async {
      final user = await userRepo.login('nobody@test.com', '123456');
      expect(user, isNull);
    });

    test('UPDATE - Update user profile', () async {
      final user = await userRepo.getUserById(1);
      expect(user, isNotNull);

      final updated = user!.copyWith(
        name: 'Budi Santoso Updated',
        phone: '081111111111',
      );
      final result = await userRepo.updateUser(updated);
      expect(result, 1);

      final verify = await userRepo.getUserById(1);
      expect(verify!.name, 'Budi Santoso Updated');
      expect(verify.phone, '081111111111');
    });

    test('UPDATE - Change password with correct old password', () async {
      final result = await userRepo.changePassword(1, '123456', 'newpass');
      expect(result, 1);

      final user = await userRepo.login('budi@test.com', 'newpass');
      expect(user, isNotNull);
    });

    test('UPDATE - Change password with wrong old password fails', () async {
      final result = await userRepo.changePassword(1, 'wrongold', 'newpass');
      expect(result, 0);
    });

    test('VERIFY - Password is stored as hash, not plaintext', () async {
      final user = await userRepo.getUserById(1);
      expect(user, isNotNull);
      expect(user!.password, isNot('newpass'));
      expect(user.password.length, 64);
      expect(PasswordHelper.verifyPassword('newpass', user.password), isTrue);
      expect(PasswordHelper.verifyPassword('wrong', user.password), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════
  // GARAGE CRUD TESTS
  // ═══════════════════════════════════════════════════════════════════
  group('GARAGE CRUD', () {
    test('CREATE - Add new garage with facilities', () async {
      final garage = GarageModel(
        ownerId: 1,
        name: 'Garasi Test 1',
        address: 'Jl. Test No. 1',
        city: 'Solo',
        length: 5.0,
        width: 3.0,
        pricePerMonth: 500000,
        roadAccess: 'Jalan 2 jalur',
        description: 'Garasi test pertama',
        facilities: ['CCTV', 'Pagar', 'Lampu'],
      );

      final id = await garageRepo.createGarage(garage);
      expect(id, greaterThan(0));

      final saved = await garageRepo.getGarageById(id);
      expect(saved, isNotNull);
      expect(saved!.name, 'Garasi Test 1');
      expect(saved.city, 'Solo');
      expect(saved.facilities, ['CCTV', 'Pagar', 'Lampu']);
    });

    test('CREATE - Add second garage', () async {
      final garage = GarageModel(
        ownerId: 1,
        name: 'Garasi Test 2',
        address: 'Jl. Test No. 2',
        city: 'Jakarta',
        length: 4.0,
        width: 2.5,
        pricePerMonth: 350000,
        roadAccess: 'Gang sempit',
        description: 'Garasi test kedua',
        facilities: ['Aman'],
      );

      final id = await garageRepo.createGarage(garage);
      expect(id, greaterThan(0));
    });

    test('READ - Get all garages', () async {
      final garages = await garageRepo.getAllGarages();
      expect(garages.length, greaterThanOrEqualTo(2));
    });

    test('READ - Get available garages only', () async {
      final garages = await garageRepo.getAvailableGarages();
      for (final g in garages) {
        expect(g.status, 'available');
      }
    });

    test('READ - Get garages by owner', () async {
      final garages = await garageRepo.getGaragesByOwner(1);
      expect(garages.length, greaterThanOrEqualTo(2));
      for (final g in garages) {
        expect(g.ownerId, 1);
      }
    });

    test('READ - Search garages by name', () async {
      final results = await garageRepo.searchGarages('Test 1');
      expect(results.length, greaterThanOrEqualTo(1));
      expect(results.first.name, contains('Test 1'));
    });

    test('READ - Search garages by city', () async {
      final results = await garageRepo.searchGarages('Jakarta');
      expect(results.length, greaterThanOrEqualTo(1));
      expect(results.first.city, 'Jakarta');
    });

    test('READ - Filter by price range', () async {
      final cheap = await garageRepo.filterByPrice(maxPrice: 400000);
      for (final g in cheap) {
        expect(g.pricePerMonth, lessThanOrEqualTo(400000));
      }

      final expensive = await garageRepo.filterByPrice(minPrice: 450000);
      for (final g in expensive) {
        expect(g.pricePerMonth, greaterThanOrEqualTo(450000));
      }
    });

    test('UPDATE - Update garage info', () async {
      final garages = await garageRepo.getGaragesByOwner(1);
      final garage = garages.first;

      final updated = garage.copyWith(
        name: 'Garasi Updated',
        pricePerMonth: 600000,
        facilities: ['CCTV', 'WiFi'],
      );
      final result = await garageRepo.updateGarage(updated);
      expect(result, 1);

      final verify = await garageRepo.getGarageById(garage.id!);
      expect(verify!.name, 'Garasi Updated');
      expect(verify.pricePerMonth, 600000);
      expect(verify.facilities, ['CCTV', 'WiFi']);
    });

    test('UPDATE - Update garage status', () async {
      final garages = await garageRepo.getGaragesByOwner(1);
      final garage = garages.first;

      final result = await garageRepo.updateGarageStatus(garage.id!, 'rented');
      expect(result, 1);

      final verify = await garageRepo.getGarageById(garage.id!);
      expect(verify!.status, 'rented');
    });

    test('DELETE - Delete garage', () async {
      final garages = await garageRepo.getGaragesByOwner(1);
      final countBefore = garages.length;

      final result = await garageRepo.deleteGarage(garages.last.id!);
      expect(result, 1);

      final after = await garageRepo.getGaragesByOwner(1);
      expect(after.length, countBefore - 1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════
  // RENTAL CRUD TESTS
  // ═══════════════════════════════════════════════════════════════════
  group('RENTAL CRUD', () {
    test('CREATE - Create rental booking', () async {
      final garages = await garageRepo.getGaragesByOwner(1);
      final garage = garages.first;

      final rental = RentalModel(
        garageId: garage.id!,
        renterId: 2,
        ownerId: 1,
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 8, 1),
        totalPrice: garage.pricePerMonth,
        note: 'Sewa 1 bulan',
      );

      final id = await rentalRepo.createRental(rental);
      expect(id, greaterThan(0));

      final saved = await rentalRepo.getRentalById(id);
      expect(saved, isNotNull);
      expect(saved!.status, 'pending');
      expect(saved.note, 'Sewa 1 bulan');
    });

    test('READ - Get rentals by renter', () async {
      final rentals = await rentalRepo.getRentalsByRenter(2);
      expect(rentals.length, greaterThanOrEqualTo(1));
      expect(rentals.first.renterId, 2);
    });

    test('READ - Get rentals by owner', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      expect(rentals.length, greaterThanOrEqualTo(1));
      expect(rentals.first.ownerId, 1);
    });

    test('UPDATE - Approve rental', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      final pending = rentals.firstWhere((r) => r.isPending);

      final result = await rentalRepo.approveRental(pending.id!);
      expect(result, 1);

      final verify = await rentalRepo.getRentalById(pending.id!);
      expect(verify!.status, 'accepted');

      // Verify garage status changed to rented
      final garage = await garageRepo.getGarageById(pending.garageId);
      expect(garage!.status, 'rented');
    });

    test('CREATE - Create another rental for reject test', () async {
      // Get available garage
      final garages = await garageRepo.getAvailableGarages();
      if (garages.isNotEmpty) {
        final rental = RentalModel(
          garageId: garages.first.id!,
          renterId: 2,
          ownerId: 1,
          startDate: DateTime(2026, 9, 1),
          endDate: DateTime(2026, 10, 1),
          totalPrice: garages.first.pricePerMonth,
        );
        final id = await rentalRepo.createRental(rental);
        expect(id, greaterThan(0));
      }
    });

    test('UPDATE - Reject rental', () async {
      // Create a new rental to reject
      final garages = await garageRepo.getAllGarages();
      expect(garages, isNotEmpty);

      final rental = RentalModel(
        garageId: garages.first.id!,
        renterId: 2,
        ownerId: 1,
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 10, 1),
        totalPrice: garages.first.pricePerMonth,
      );
      final id = await rentalRepo.createRental(rental);

      final result = await rentalRepo.rejectRental(id);
      expect(result, 1);

      final verify = await rentalRepo.getRentalById(id);
      expect(verify!.status, 'rejected');
    });

    test('CREATE - Rental for cancel test', () async {
      final garages = await garageRepo.getAvailableGarages();
      if (garages.isNotEmpty) {
        final rental = RentalModel(
          garageId: garages.first.id!,
          renterId: 2,
          ownerId: 1,
          startDate: DateTime(2026, 11, 1),
          endDate: DateTime(2026, 12, 1),
          totalPrice: garages.first.pricePerMonth,
        );
        final id = await rentalRepo.createRental(rental);
        expect(id, greaterThan(0));

        // Cancel it
        final result = await rentalRepo.cancelRental(id);
        expect(result, 1);

        final verify = await rentalRepo.getRentalById(id);
        expect(verify!.status, 'cancelled');
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════
  // CONTRACT CRUD TESTS
  // ═══════════════════════════════════════════════════════════════════
  group('CONTRACT CRUD', () {
    test('CREATE - Create contract for approved rental', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      final accepted = rentals.firstWhere((r) => r.isAccepted);

      final contract = ContractModel(
        rentalId: accepted.id!,
        contractNumber: contractRepo.generateContractNumber(),
        ownerName: 'Budi Santoso Updated',
        ownerEmail: 'budi@test.com',
        ownerPhone: '081111111111',
        renterName: 'Andi Pratama',
        renterEmail: 'andi@test.com',
        renterPhone: '085678901234',
        garageName: 'Garasi Updated',
        garageAddress: 'Jl. Test No. 1, Solo',
        startDate: accepted.startDate,
        endDate: accepted.endDate,
        totalPrice: accepted.totalPrice,
        termsText: ContractModel.generateTermsText(),
      );

      final id = await contractRepo.createContract(contract);
      expect(id, greaterThan(0));
    });

    test('READ - Get contract by rental ID', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      final accepted = rentals.firstWhere((r) => r.isAccepted);

      final contract = await contractRepo.getContractByRentalId(accepted.id!);
      expect(contract, isNotNull);
      expect(contract!.ownerName, 'Budi Santoso Updated');
      expect(contract.renterName, 'Andi Pratama');
      expect(contract.termsText, isNotEmpty);
    });

    test('UPDATE - Update renter signature path', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      final accepted = rentals.firstWhere((r) => r.isAccepted);

      final result = await contractRepo.updateRenterSignature(
          accepted.id!, '/path/to/signature.png');
      expect(result, 1);

      final contract = await contractRepo.getContractByRentalId(accepted.id!);
      expect(contract!.renterSignaturePath, '/path/to/signature.png');
    });

    test('UPDATE - Update owner signature path', () async {
      final rentals = await rentalRepo.getRentalsByOwner(1);
      final accepted = rentals.firstWhere((r) => r.isAccepted);

      final result = await contractRepo.updateOwnerSignature(
          accepted.id!, '/path/to/owner_sig.png');
      expect(result, 1);

      final contract = await contractRepo.getContractByRentalId(accepted.id!);
      expect(contract!.ownerSignaturePath, '/path/to/owner_sig.png');
    });

    test('READ - Contract number is unique', () async {
      final num1 = contractRepo.generateContractNumber();
      await Future.delayed(const Duration(milliseconds: 2));
      final num2 = contractRepo.generateContractNumber();
      expect(num1, isNot(equals(num2)));
    });
  });
}
