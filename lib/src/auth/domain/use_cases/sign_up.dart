import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class SignUp extends UseCase<void, SignUpParams> {
    SignUp({required AuthRepository repository}) : _repository = repository;
    final AuthRepository _repository;

  @override
  ResultFuture<void> call(SignUpParams params) {
    throw UnimplementedError();
  }
}

class SignUpParams {}


