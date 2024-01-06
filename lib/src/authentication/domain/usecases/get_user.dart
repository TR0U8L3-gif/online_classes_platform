import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetUser implements UseCase<User, GetUserParams>{
  const GetUser(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<User> call(GetUserParams params) {
    return _repository.getUser(id: params.id);
  }
}

class GetUserParams extends Equatable{
  const GetUserParams({required this.id});
  final String id;
  @override
  List<Object?> get props => [id];

}
