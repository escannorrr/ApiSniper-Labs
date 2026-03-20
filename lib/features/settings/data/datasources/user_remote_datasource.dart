import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UpdateProfileRequest request);
  Future<void> changePassword(ChangePasswordRequest request);
  Future<void> deleteAccount();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserProfile> getProfile() async {
    final response = await apiClient.get('/auth/me');
    return UserProfile.fromJson(response.data);
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    final response = await apiClient.patch(
      '/users/profile',
      data: request.toJson(),
    );
    return UserProfile.fromJson(response.data);
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await apiClient.post(
      '/users/change-password',
      data: request.toJson(),
    );
  }

  @override
  Future<void> deleteAccount() async {
    await apiClient.delete('/users/account');
  }
}
