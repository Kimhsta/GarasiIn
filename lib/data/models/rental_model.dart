/// Rental model (replaces old BookingModel) compatible with SQLite and UI
class RentalModel {
  final int? id;
  final int garageId;
  final int renterId;
  final int ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final String status; // 'pending', 'accepted', 'rejected', 'cancelled'
  final String? note;
  final String? createdAt;
  final String? updatedAt;

  // Joined fields for UI convenience (not stored in rentals table)
  final String? garageName;
  final String? renterName;
  final String? garageAddress;

  const RentalModel({
    this.id,
    required this.garageId,
    required this.renterId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    this.status = 'pending',
    this.note,
    this.createdAt,
    this.updatedAt,
    this.garageName,
    this.renterName,
    this.garageAddress,
  });

  factory RentalModel.fromMap(Map<String, dynamic> map) {
    return RentalModel(
      id: map['id'] as int?,
      garageId: map['garage_id'] as int,
      renterId: map['renter_id'] as int,
      ownerId: map['owner_id'] as int,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      totalPrice: map['total_price'] as int,
      status: (map['status'] as String?) ?? 'pending',
      note: map['note'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      garageName: map['garage_name'] as String?,
      renterName: map['renter_name'] as String?,
      garageAddress: map['garage_address'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'garage_id': garageId,
      'renter_id': renterId,
      'owner_id': ownerId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
    };
    if (id != null) map['id'] = id;
    if (note != null) map['note'] = note;
    if (createdAt != null) map['created_at'] = createdAt;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    return map;
  }

  RentalModel copyWith({
    int? id,
    int? garageId,
    int? renterId,
    int? ownerId,
    DateTime? startDate,
    DateTime? endDate,
    int? totalPrice,
    String? status,
    String? note,
    String? createdAt,
    String? updatedAt,
    String? garageName,
    String? renterName,
    String? garageAddress,
  }) {
    return RentalModel(
      id: id ?? this.id,
      garageId: garageId ?? this.garageId,
      renterId: renterId ?? this.renterId,
      ownerId: ownerId ?? this.ownerId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      garageName: garageName ?? this.garageName,
      renterName: renterName ?? this.renterName,
      garageAddress: garageAddress ?? this.garageAddress,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';
}
