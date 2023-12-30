import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/authentication/domain/repositories/auth_repository.dart';

import '../entities/user.dart';

class GetUsers extends UseCase<List<User>, NoParams>{
  GetUsers(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<List<User>> call(NoParams params) {
    return _repository.getUsers();
  }
}
