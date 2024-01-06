
import '../../../../core/utils/typedef.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<void> createUser({
    required String name,
    required String? avatar,
    required String createdAt,
  });

  ResultFuture<User> getUser({required String id});

  ResultFuture<List<User>> getUsers();


}
