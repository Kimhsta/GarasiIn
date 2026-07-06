import '../datasources/local/user_local_datasource.dart';
import '../models/user_model.dart';

/// Repository for user operations
class UserRepository {
  final UserLocalDatasource _datasource = UserLocalDatasource();

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final user = UserModel(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
    final id = await _datasource.insertUser(user);
    return user.copyWith(id: id);
  }

  Future<UserModel?> login(String email, String password) async {
    return await _datasource.getUserByEmailAndPassword(email, password);
  }

  Future<UserModel?> getUserById(int id) async {
    return await _datasource.getUserById(id);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    return await _datasource.getUserByEmail(email);
  }

  Future<int> updateUser(UserModel user) async {
    return await _datasource.updateUser(user);
  }

  Future<int> changePassword(
      int userId, String oldPassword, String newPassword) async {
    return await _datasource.changePassword(userId, oldPassword, newPassword);
  }
}
