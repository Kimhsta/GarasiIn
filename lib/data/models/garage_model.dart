/// Garage model compatible with SQLite and existing UI
class GarageModel {
  final int? id;
  final int ownerId;
  final String name;
  final String address;
  final String city;
  final double length;
  final double width;
  final int pricePerMonth;
  final String status; // 'available' or 'rented'
  final String roadAccess;
  final String description;
  final List<String> facilities;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;

  const GarageModel({
    this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    this.city = 'Solo',
    required this.length,
    required this.width,
    required this.pricePerMonth,
    this.status = 'available',
    required this.roadAccess,
    this.description = '',
    this.facilities = const [],
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory GarageModel.fromMap(Map<String, dynamic> map,
      {List<String>? facilities}) {
    return GarageModel(
      id: map['id'] as int?,
      ownerId: map['owner_id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      city: (map['city'] as String?) ?? 'Solo',
      length: (map['length'] as num).toDouble(),
      width: (map['width'] as num).toDouble(),
      pricePerMonth: map['price_per_month'] as int,
      status: (map['status'] as String?) ?? 'available',
      roadAccess: map['road_access'] as String,
      description: (map['description'] as String?) ?? '',
      facilities: facilities ?? [],
      imagePath: map['image_path'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'city': city,
      'length': length,
      'width': width,
      'price_per_month': pricePerMonth,
      'status': status,
      'road_access': roadAccess,
      'description': description,
    };
    if (id != null) map['id'] = id;
    if (imagePath != null) map['image_path'] = imagePath;
    if (createdAt != null) map['created_at'] = createdAt;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    return map;
  }

  GarageModel copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? address,
    String? city,
    double? length,
    double? width,
    int? pricePerMonth,
    String? status,
    String? roadAccess,
    String? description,
    List<String>? facilities,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return GarageModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      length: length ?? this.length,
      width: width ?? this.width,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      status: status ?? this.status,
      roadAccess: roadAccess ?? this.roadAccess,
      description: description ?? this.description,
      facilities: facilities ?? this.facilities,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAvailable => status == 'available';
  bool get isRented => status == 'rented';
  double get area => length * width;
}
