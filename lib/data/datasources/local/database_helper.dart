import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/password_helper.dart';

/// SQLite database helper for GarasiIn
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;
  static Database? testDatabase;

  Future<Database> get database async {
    if (testDatabase != null) return testDatabase!;
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ─── Users table ──────────────────────────────────────────────
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

    // ─── Garages table ────────────────────────────────────────────
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

    // ─── Garage facilities table ──────────────────────────────────
    await db.execute('''
      CREATE TABLE garage_facilities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        garage_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        FOREIGN KEY(garage_id) REFERENCES garages(id) ON DELETE CASCADE
      )
    ''');

    // ─── Rentals table ────────────────────────────────────────────
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

    // ─── Contracts table ──────────────────────────────────────────
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

    // ─── Seed data ────────────────────────────────────────────────
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Insert owner user
    await db.insert('users', {
      'name': 'Budi Santoso',
      'email': 'pemilik@gmail.com',
      'phone': '0812-3456-7890',
      'password': PasswordHelper.hashPassword('123456'),
      'role': 'owner',
    });

    // Insert renter user
    await db.insert('users', {
      'name': 'Andi Pratama',
      'email': 'penyewa@gmail.com',
      'phone': '0856-7890-1234',
      'password': PasswordHelper.hashPassword('123456'),
      'role': 'renter',
    });

    // Insert garages
    final g1 = await db.insert('garages', {
      'owner_id': 1,
      'name': 'Garasi Rumah Pak Budi',
      'address': 'Jl. Melati No. 10, Solo',
      'city': 'Solo',
      'length': 5.0,
      'width': 3.0,
      'price_per_month': 500000,
      'status': 'available',
      'road_access': 'Jalan masuk cukup untuk mobil keluarga',
      'description':
          'Garasi aman, dekat jalan utama, cocok untuk parkir bulanan.',
    });

    final g2 = await db.insert('garages', {
      'owner_id': 1,
      'name': 'Garasi Belakang Rumah',
      'address': 'Jl. Kenanga No. 5, Solo',
      'city': 'Solo',
      'length': 4.5,
      'width': 3.0,
      'price_per_month': 450000,
      'status': 'available',
      'road_access': 'Akses gang cukup lebar',
      'description':
          'Area parkir bersih dan nyaman untuk mobil kecil.',
    });

    final g3 = await db.insert('garages', {
      'owner_id': 1,
      'name': 'Garasi Strategis Solo',
      'address': 'Jl. Ahmad Yani, Solo',
      'city': 'Solo',
      'length': 5.0,
      'width': 3.5,
      'price_per_month': 550000,
      'status': 'rented',
      'road_access': 'Dekat jalan besar',
      'description':
          'Cocok untuk pengguna yang sering beraktivitas di pusat kota.',
    });

    // Insert facilities
    for (final f in ['Aman', 'Dekat Jalan', 'CCTV']) {
      await db.insert('garage_facilities', {
        'garage_id': g1,
        'name': f,
      });
    }
    for (final f in ['Teduh', 'Pagar', 'Lampu']) {
      await db.insert('garage_facilities', {
        'garage_id': g2,
        'name': f,
      });
    }
    for (final f in ['CCTV', 'Dekat Jalan', 'Aman']) {
      await db.insert('garage_facilities', {
        'garage_id': g3,
        'name': f,
      });
    }
  }
}
