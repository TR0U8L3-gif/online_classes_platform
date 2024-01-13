import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class SignIn extends UseCase<LocalUser, SignInParams> {
  SignIn({required AuthRepository repository}) : _repository = repository;
  final AuthRepository _repository;

  @override
  ResultFuture<LocalUser> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
