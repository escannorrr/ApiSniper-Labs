import '../../data/models/user_profile_model.dart';

abstract class UserRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UpdateProfileRequest request);
  Future<void> changePassword(ChangePasswordRequest request);
  Future<void> deleteAccount();
}
