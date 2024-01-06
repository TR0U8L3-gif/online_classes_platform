import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CreateUser _createUser;
  final GetUser _getUser;
  final GetUsers _getUsers;

  AuthCubit({
    required GetUser getUser,
    required GetUsers getUsers,
    required CreateUser createUser,
  })
      : _createUser = createUser,
        _getUser = getUser,
        _getUsers = getUsers,
        super(const AuthInitial());

  Future<void> createUser({
    required String name,
    required String? avatar,
    required String createdAt,
  }) async {
    emit(const AuthCreatingUser());

    final result = await _createUser(CreateUserParams(
      name: name,
      avatar: avatar,
      createdAt: createdAt,
    ));

    result.fold(
          (failure) => emit(AuthError(message: failure.errorMessage)),
          (success) => emit(const AuthUserCreated()),
    );
  }

  Future<void> getUser({
    required String id,
  }) async {
    emit(const AuthGettingUser());
    final result = await _getUser(GetUserParams(id: id));

    result.fold(
          (failure) => emit(AuthError(message: failure.errorMessage)),
          (success) => emit(AuthUserLoaded(user: success)),
    );
  }

  Future<void> getUsers() async {
    emit(const AuthGettingUsers());
    final result = await _getUsers(NoParams());

    result.fold(
          (failure) => emit(AuthError(message: failure.errorMessage)),
          (success) => emit(AuthUsersLoaded(users: success)),
    );
  }
}
