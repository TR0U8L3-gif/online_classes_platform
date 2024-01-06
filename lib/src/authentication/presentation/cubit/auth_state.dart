part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class AuthCreatingUser extends AuthState {
  const AuthCreatingUser();
}

class AuthUserCreated extends AuthState {
  const AuthUserCreated();
}

class AuthGettingUser extends AuthState {
  const AuthGettingUser();
}

class AuthUserLoaded extends AuthState {
  const AuthUserLoaded({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class AuthGettingUsers extends AuthState {
  const AuthGettingUsers();
}

class AuthUsersLoaded extends AuthState {
  const AuthUsersLoaded({required this.users});

  final List<User> users;

  @override
  List<Object> get props => users.map((user) => user.id).toList();
}
