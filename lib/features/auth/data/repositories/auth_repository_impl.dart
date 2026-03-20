import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<User> login(String email, String password) async {
    final loginData = await remoteDataSource.login(email, password);
    final token = loginData['access_token'];
    
    // Store token
    await sharedPreferences.setString(_tokenKey, token);
    
    // Update ApiClient with new token (if possible, or it will be picked up on next request)
    // For now, let's fetch the user profile
    final user = await remoteDataSource.getMe();
    await _cacheUser(user);
    return user;
  }

  @override
  Future<User> signup(String name, String email, String password) async {
    // Backend doesn't take name in signup, so we just send email/password
    await remoteDataSource.signup(email, password);
    // After signup, login to get token and user profile
    return await login(email, password);
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_userKey);
    await sharedPreferences.remove(_tokenKey); // Changed to use _tokenKey
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson != null) {
      final user = UserModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(userJson)),
      );
      // We could optionally refresh from /auth/me here
      return user;
    }
    return null;
  }

  @override
  Future<User> getMe() async {
    final user = await remoteDataSource.getMe();
    await _cacheUser(user);
    return user;
  }

  Future<void> _cacheUser(UserModel user) async {
    await sharedPreferences.setString(_userKey, json.encode(user.toJson()));
  }
}
