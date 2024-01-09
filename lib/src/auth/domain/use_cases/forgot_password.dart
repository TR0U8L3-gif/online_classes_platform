import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
    ForgotPassword({required AuthRepository repository}) : _repository = repository;
    final AuthRepository _repository;

  @override
  ResultFuture<void> call(ForgotPasswordParams params) {
    throw UnimplementedError();
  }
}

class ForgotPasswordParams {}
