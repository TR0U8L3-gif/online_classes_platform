
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  });

  ResultFuture<User> getUser({required String id});

  ResultFuture<List<User>> getUsers();


}
