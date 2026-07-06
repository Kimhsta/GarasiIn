/// User model compatible with SQLite and existing UI
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role; // 'owner' or 'renter'
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
      imagePath: map['image_path'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
    if (id != null) map['id'] = id;
    if (imagePath != null) map['image_path'] = imagePath;
    if (createdAt != null) map['created_at'] = createdAt;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    return map;
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? role,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOwner => role == 'owner';
  bool get isRenter => role == 'renter';
}
