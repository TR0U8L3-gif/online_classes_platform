import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class UpdateUser extends UseCase<void, UpdateUserParams> {
    UpdateUser({required AuthRepository repository}) : _repository = repository;
    final AuthRepository _repository;

  @override
  ResultFuture<void> call(UpdateUserParams params) {
    throw UnimplementedError();
  }
}

class UpdateUserParams {}
