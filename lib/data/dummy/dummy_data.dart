// Dummy data models & mock data for GarasiIn FE

enum UserRole { owner, renter }

enum GarageStatus { available, rented }

enum BookingStatus { pending, accepted, rejected }

// ─── Models ────────────────────────────────────────────────────────────────

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
  });
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
  });
}

// ─── Dummy Data ─────────────────────────────────────────────────────────────

class DummyData {
  DummyData._();

  static const UserModel ownerUser = UserModel(
    id: 'u001',
    name: 'Budi Santoso',
    email: 'pemilik@gmail.com',
    phone: '0812-3456-7890',
    role: UserRole.owner,
  );

  static const UserModel renterUser = UserModel(
    id: 'u002',
    name: 'Andi Pratama',
    email: 'penyewa@gmail.com',
    phone: '0856-7890-1234',
    role: UserRole.renter,
  );

  static final List<GarageModel> garages = [
    const GarageModel(
      id: 'g001',
      ownerId: 'u001',
      name: 'Garasi Rumah Pak Budi',
      address: 'Jl. Melati No. 10',
      city: 'Solo',
      length: 5.0,
      width: 3.0,
      pricePerMonth: 500000,
      status: GarageStatus.available,
      roadAccess: 'Jalan 2 jalur, mudah dilalui',
      description:
          'Garasi bersih dan aman, cocok untuk 1 mobil ukuran sedang. Lokasi strategis dekat pusat kota Solo. Dilengkapi penerangan dan CCTV.',
      facilities: ['Aman', 'Dekat Jalan', 'CCTV'],
      imageUrl: 'assets/images/garage_1.jpg',
    ),
    const GarageModel(
      id: 'g002',
      ownerId: 'u001',
      name: 'Garasi Belakang Rumah',
      address: 'Jl. Kenanga No. 5',
      city: 'Solo',
      length: 4.5,
      width: 3.0,
      pricePerMonth: 450000,
      status: GarageStatus.available,
      roadAccess: 'Jalan 1 jalur, cukup lebar',
      description:
          'Garasi di belakang rumah, tenang dan nyaman. Akses gerbang terpisah. Cocok untuk penyewa yang menginginkan privasi.',
      facilities: ['Aman', 'Tenang'],
      imageUrl: 'assets/images/garage_2.jpg',
    ),
    const GarageModel(
      id: 'g003',
      ownerId: 'u001',
      name: 'Garasi Strategis Solo',
      address: 'Jl. Ahmad Yani',
      city: 'Solo',
      length: 5.0,
      width: 3.5,
      pricePerMonth: 550000,
      status: GarageStatus.rented,
      roadAccess: 'Jalan protokol, sangat mudah diakses',
      description:
          'Garasi premium di lokasi paling strategis Solo. Dekat dengan pusat perbelanjaan dan kantor. Sudah disewa dan akan tersedia bulan depan.',
      facilities: ['Aman', 'Dekat Jalan', 'CCTV', 'Penerangan'],
      imageUrl: 'assets/images/garage_3.jpg',
    ),
  ];

  static List<GarageModel> get ownerGarages =>
      garages.where((g) => g.ownerId == ownerUser.id).toList();

  static List<GarageModel> get availableGarages =>
      garages.where((g) => g.status == GarageStatus.available).toList();

  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'b001',
      garageId: 'g001',
      garageName: 'Garasi Rumah Pak Budi',
      renterId: 'u002',
      renterName: 'Andi Pratama',
      ownerId: 'u001',
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2024, 7, 31),
      totalPrice: 500000,
      status: BookingStatus.pending,
      note: 'Saya ingin menyewa untuk 1 bulan terlebih dahulu.',
    ),
    BookingModel(
      id: 'b002',
      garageId: 'g003',
      garageName: 'Garasi Strategis Solo',
      renterId: 'u002',
      renterName: 'Siti Rahayu',
      ownerId: 'u001',
      startDate: DateTime(2024, 5, 1),
      endDate: DateTime(2024, 6, 30),
      totalPrice: 1100000,
      status: BookingStatus.accepted,
      note: null,
    ),
    BookingModel(
      id: 'b003',
      garageId: 'g002',
      garageName: 'Garasi Belakang Rumah',
      renterId: 'u002',
      renterName: 'Andi Pratama',
      ownerId: 'u001',
      startDate: DateTime(2024, 4, 1),
      endDate: DateTime(2024, 4, 30),
      totalPrice: 450000,
      status: BookingStatus.rejected,
      note: 'Garasi sudah terisi.',
    ),
  ];

  static List<BookingModel> get renterBookings =>
      bookings.where((b) => b.renterId == renterUser.id).toList();

  static List<BookingModel> get ownerBookings =>
      bookings.where((b) => b.ownerId == ownerUser.id).toList();
}
