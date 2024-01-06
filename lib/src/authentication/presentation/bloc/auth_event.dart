part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class CreateUserEvent extends AuthEvent {
  final String name;
  final String avatar;
  final String createdAt;

  const CreateUserEvent({
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [name, avatar, createdAt];
}

class GetUsersEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class GetUserEvent extends AuthEvent {
  final String id;

  const GetUserEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
