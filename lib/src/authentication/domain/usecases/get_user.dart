import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';

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
