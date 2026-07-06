// Backward-compatible dummy data file.
// Enums and old model classes are kept so existing UI can compile.
// New backend uses data/models/ instead.

import '../models/garage_model.dart' as db;
import '../models/rental_model.dart' as db;
import '../models/user_model.dart' as db;

enum UserRole { owner, renter }
enum GarageStatus { available, rented }
enum BookingStatus { pending, accepted, rejected, cancelled }

// ─── Legacy Models (kept for UI backward compat) ────────────────────────

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  /// Create from new DB model
  factory UserModel.fromDb(db.UserModel u) => UserModel(
    id: u.id?.toString() ?? '',
    name: u.name,
    email: u.email,
    phone: u.phone,
    role: u.role == 'owner' ? UserRole.owner : UserRole.renter,
  );
}

class GarageModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String city;
  final double length;
  final double width;
  final int pricePerMonth;
  final GarageStatus status;
  final String roadAccess;
  final String description;
  final List<String> facilities;
  final String imageUrl;
  final int? dbId;

  const GarageModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.city,
    required this.length,
    required this.width,
    required this.pricePerMonth,
    required this.status,
    required this.roadAccess,
    required this.description,
    required this.facilities,
    required this.imageUrl,
    this.dbId,
  });

  factory GarageModel.fromDb(db.GarageModel g) => GarageModel(
    id: g.id?.toString() ?? '',
    ownerId: g.ownerId.toString(),
    name: g.name,
    address: g.address,
    city: g.city,
    length: g.length,
    width: g.width,
    pricePerMonth: g.pricePerMonth,
    status: g.status == 'available'
        ? GarageStatus.available
        : GarageStatus.rented,
    roadAccess: g.roadAccess,
    description: g.description,
    facilities: g.facilities,
    imageUrl: g.imagePath ?? '',
    dbId: g.id,
  );

  db.GarageModel toDb() => db.GarageModel(
    id: dbId,
    ownerId: int.tryParse(ownerId) ?? 0,
    name: name,
    address: address,
    city: city,
    length: length,
    width: width,
    pricePerMonth: pricePerMonth,
    status: status == GarageStatus.available ? 'available' : 'rented',
    roadAccess: roadAccess,
    description: description,
    facilities: facilities,
    imagePath: imageUrl.isNotEmpty ? imageUrl : null,
  );
}

class BookingModel {
  final String id;
  final String garageId;
  final String garageName;
  final String renterId;
  final String renterName;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final BookingStatus status;
  final String? note;
  final int? dbId;

  const BookingModel({
    required this.id,
    required this.garageId,
    required this.garageName,
    required this.renterId,
    required this.renterName,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.note,
    this.dbId,
  });

  factory BookingModel.fromDb(db.RentalModel r) {
    BookingStatus bs;
    switch (r.status) {
      case 'accepted': bs = BookingStatus.accepted; break;
      case 'rejected': bs = BookingStatus.rejected; break;
      case 'cancelled': bs = BookingStatus.cancelled; break;
      default: bs = BookingStatus.pending;
    }
    return BookingModel(
      id: r.id?.toString() ?? '',
      garageId: r.garageId.toString(),
      garageName: r.garageName ?? '',
      renterId: r.renterId.toString(),
      renterName: r.renterName ?? '',
      ownerId: r.ownerId.toString(),
      startDate: r.startDate,
      endDate: r.endDate,
      totalPrice: r.totalPrice,
      status: bs,
      note: r.note,
      dbId: r.id,
    );
  }
}

// ─── DummyData class (now only used as fallback, seed data in DB) ───────

class DummyData {
  DummyData._();

  static const UserModel ownerUser = UserModel(
    id: '1', name: 'Budi Santoso', email: 'pemilik@gmail.com',
    phone: '0812-3456-7890', role: UserRole.owner,
  );

  static const UserModel renterUser = UserModel(
    id: '2', name: 'Andi Pratama', email: 'penyewa@gmail.com',
    phone: '0856-7890-1234', role: UserRole.renter,
  );

  static final List<GarageModel> garages = [];
  static List<GarageModel> get ownerGarages => [];
  static List<GarageModel> get availableGarages => [];
  static final List<BookingModel> bookings = [];
  static List<BookingModel> get renterBookings => [];
  static List<BookingModel> get ownerBookings => [];
}
