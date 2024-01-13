import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
  ForgotPassword({required AuthRepository repository})
      : _repository = repository;
  final AuthRepository _repository;

  @override
  ResultFuture<void> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
