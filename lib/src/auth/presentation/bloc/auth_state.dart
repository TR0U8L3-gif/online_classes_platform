part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn({required this.user});

  final LocalUser user;

  @override
  List<Object> get props => [user];
}

class AuthSignedUp extends AuthState {
  const AuthSignedUp();
}

class AuthForgotPasswordSend extends AuthState {
  const AuthForgotPasswordSend();
}

class AuthUserUpdated extends AuthState {
  const AuthUserUpdated();
}
