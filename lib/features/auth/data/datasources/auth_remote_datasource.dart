import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<UserModel> signup(String email, String password);
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final formData = FormData.fromMap({
      'username': email,
      'password': password,
    });
    final response = await apiClient.post('/auth/login', data: formData);
    return response.data;
  }

  @override
  Future<UserModel> signup(String email, String password) async {
    final response = await apiClient.post('/auth/register', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await apiClient.get('/auth/me');
    return UserModel.fromJson(response.data);
  }
}
