/// Contract model for rental agreements
class ContractModel {
  final int? id;
  final int rentalId;
  final String contractNumber;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String renterName;
  final String renterEmail;
  final String renterPhone;
  final String garageName;
  final String garageAddress;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final String? note;
  final String? renterSignaturePath;
  final String? ownerSignaturePath;
  final String termsText;
  final String? createdAt;

  const ContractModel({
    this.id,
    required this.rentalId,
    required this.contractNumber,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.renterName,
    required this.renterEmail,
    required this.renterPhone,
    required this.garageName,
    required this.garageAddress,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    this.note,
    this.renterSignaturePath,
    this.ownerSignaturePath,
    required this.termsText,
    this.createdAt,
  });

  factory ContractModel.fromMap(Map<String, dynamic> map) {
    return ContractModel(
      id: map['id'] as int?,
      rentalId: map['rental_id'] as int,
      contractNumber: map['contract_number'] as String,
      ownerName: map['owner_name'] as String,
      ownerEmail: map['owner_email'] as String,
      ownerPhone: map['owner_phone'] as String,
      renterName: map['renter_name'] as String,
      renterEmail: map['renter_email'] as String,
      renterPhone: map['renter_phone'] as String,
      garageName: map['garage_name'] as String,
      garageAddress: map['garage_address'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      totalPrice: map['total_price'] as int,
      note: map['note'] as String?,
      renterSignaturePath: map['renter_signature_path'] as String?,
      ownerSignaturePath: map['owner_signature_path'] as String?,
      termsText: map['terms_text'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'rental_id': rentalId,
      'contract_number': contractNumber,
      'owner_name': ownerName,
      'owner_email': ownerEmail,
      'owner_phone': ownerPhone,
      'renter_name': renterName,
      'renter_email': renterEmail,
      'renter_phone': renterPhone,
      'garage_name': garageName,
      'garage_address': garageAddress,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_price': totalPrice,
      'terms_text': termsText,
    };
    if (id != null) map['id'] = id;
    if (note != null) map['note'] = note;
    if (renterSignaturePath != null) {
      map['renter_signature_path'] = renterSignaturePath;
    }
    if (ownerSignaturePath != null) {
      map['owner_signature_path'] = ownerSignaturePath;
    }
    if (createdAt != null) map['created_at'] = createdAt;
    return map;
  }

  ContractModel copyWith({
    int? id,
    int? rentalId,
    String? contractNumber,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    String? renterName,
    String? renterEmail,
    String? renterPhone,
    String? garageName,
    String? garageAddress,
    DateTime? startDate,
    DateTime? endDate,
    int? totalPrice,
    String? note,
    String? renterSignaturePath,
    String? ownerSignaturePath,
    String? termsText,
    String? createdAt,
  }) {
    return ContractModel(
      id: id ?? this.id,
      rentalId: rentalId ?? this.rentalId,
      contractNumber: contractNumber ?? this.contractNumber,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      renterName: renterName ?? this.renterName,
      renterEmail: renterEmail ?? this.renterEmail,
      renterPhone: renterPhone ?? this.renterPhone,
      garageName: garageName ?? this.garageName,
      garageAddress: garageAddress ?? this.garageAddress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      note: note ?? this.note,
      renterSignaturePath: renterSignaturePath ?? this.renterSignaturePath,
      ownerSignaturePath: ownerSignaturePath ?? this.ownerSignaturePath,
      termsText: termsText ?? this.termsText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Generate default terms text
  static String generateTermsText() {
    return '''1. Penyewa wajib merawat dan menjaga kebersihan garasi selama masa sewa.
2. Penyewa tidak diperkenankan menyewakan kembali garasi kepada pihak lain.
3. Pembatalan sewa harus disampaikan minimal 7 hari sebelumnya.
4. Pemilik garasi berhak meninjau kondisi garasi setiap bulan.
5. Keterlambatan pembayaran dikenakan denda sesuai kesepakatan.''';
  }
}
