import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/utils/enums/update_user.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/forgot_password.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_in.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_up.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<AuthEvent>((_, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) => emit(
        AuthError(message: l.errorMessage),
      ),
      (r) => emit(
        AuthSignedIn(user: r),
      ),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (l) => emit(
        AuthError(message: l.errorMessage),
      ),
      (r) => emit(
        const AuthSignedUp(),
      ),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (l) => emit(
        AuthError(message: l.errorMessage),
      ),
      (r) => emit(
        const AuthForgotPasswordSend(),
      ),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (l) => emit(
        AuthError(message: l.errorMessage),
      ),
      (r) => emit(
        const AuthUserUpdated(),
      ),
    );
  }
}
