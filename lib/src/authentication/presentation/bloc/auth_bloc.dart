import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUser createUser;
  final GetUser getUser;
  final GetUsers getUsers;

  AuthBloc({
    required this.createUser,
    required this.getUser,
    required this.getUsers,
  }) : super(const AuthInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUserEvent>(_getUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCreatingUser());
    final result = await createUser(CreateUserParams(
      name: event.name,
      avatar: event.avatar,
      createdAt: event.createdAt,
    ));

    result.fold(
      (failure) => emit(AuthError(message: failure.errorMessage)),
      (success) => emit(const AuthUserCreated()),
    );
  }

  Future<void> _getUserHandler(
    GetUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthGettingUser());
    final result = await getUser(GetUserParams(id: event.id));

    result.fold(
          (failure) => emit(AuthError(message: failure.errorMessage)),
          (success) => emit(AuthUserLoaded(user: success)),
    );
  }

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthGettingUsers());
    final result = await getUsers(NoParams());

    result.fold(
          (failure) => emit(AuthError(message: failure.errorMessage)),
          (success) => emit(AuthUsersLoaded(users: success)),
    );
  }
  
}
