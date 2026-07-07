import '../../models/user_model.dart';
import 'database_helper.dart';
import '../../../core/utils/password_helper.dart';

/// Local datasource for user CRUD operations
class UserLocalDatasource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertUser(UserModel user) async {
    final db = await _dbHelper.database;
    final hashedUser = user.copyWith(
      password: PasswordHelper.hashPassword(user.password),
    );
    return await db.insert('users', hashedUser.toMap());
  }

  Future<UserModel?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isEmpty) return null;
    final user = UserModel.fromMap(result.first);
    if (!PasswordHelper.verifyPassword(password, user.password)) return null;
    return user;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<int> updateUser(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'image_path': user.imagePath,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> changePassword(
      int userId, String oldPassword, String newPassword) async {
    final db = await _dbHelper.database;
    final user = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (user.isEmpty) return 0;

    final existingUser = UserModel.fromMap(user.first);
    if (!PasswordHelper.verifyPassword(oldPassword, existingUser.password)) {
      return 0;
    }

    return await db.update(
      'users',
      {
        'password': PasswordHelper.hashPassword(newPassword),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
