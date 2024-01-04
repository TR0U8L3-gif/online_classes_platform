import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetUser implements UseCase<User, Params>{
  const GetUser(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<User> call(Params params) {
    return _repository.getUser(id: params.id);
  }
}

class Params extends Equatable{
  const Params({required this.id});
  final String id;
  @override
  List<Object?> get props => [id];

}
