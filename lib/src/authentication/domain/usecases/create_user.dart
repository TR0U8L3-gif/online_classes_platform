import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/authentication/domain/repositories/auth_repository.dart';

class CreateUser implements UseCase<void, Params> {
  const CreateUser(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<void> call(Params params) {
    return _repository.createUser(
      name: params.name,
      avatar: params.avatar,
      createdAt: params.createdAt,
    );
  }
}

class Params extends Equatable {
  final String name;
  final String avatar;
  final String createdAt;

  Params({
    required this.name,
    required String? avatar,
    required String? createdAt,
  })  : avatar = avatar ?? "",
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  Params.empty() : this(name: "", avatar: "", createdAt: "");

  @override
  List<Object?> get props => [name, avatar, createdAt];
}
