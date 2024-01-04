
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  });

  Future<UserModel> getUser({required String id});

  Future<List<UserModel>> getUsers();


}
