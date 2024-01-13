import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/utils/enums/update_user.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/forgot_password.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_in.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_up.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/update_user.dart';
import 'package:online_classes_platform/src/auth/presentation/bloc/auth_bloc.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tEmail = 'email@domain.com';
  const tPassword = 'password';
  const tFullName = 'FullName';
  const tUpdateUserAction = UpdateUserAction.email;
  const tUser = LocalUser(
    uid: 'uid',
    email: 'email',
    points: 0,
    fullName: 'fullName',
  );

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      SignInParams(
        email: tEmail,
        password: tPassword,
      ),
    );

    registerFallbackValue(
      SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    registerFallbackValue(
      ForgotPasswordParams(email: tEmail),
    );

    registerFallbackValue(
      UpdateUserParams(action: tUpdateUserAction, userData: tEmail),
    );
  });

  tearDown(() => authBloc.close());

  test(
    ' initial state should be [AuthInitial]',
    () async {
      expect(authBloc.state, const AuthInitial());
    },
  );

  group('SignInEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when [SingInEvent] is added',
      build: () {
        when(() => signIn(any()))
            .thenAnswer((invocation) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignInEvent(email: tEmail, password: tPassword),
      ),
      expect: () => [const AuthLoading(), const AuthSignedIn(user: tUser)],
      verify: (_) {
        verify(() =>
            signIn(const SignInParams(email: tEmail, password: tPassword)));
      },
    );

    const tServerFailure = ServerFailure(
      message: 'user-not-found',
      statusCode: 'There is no user record corresponding to this id',
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when [SingInEvent] is added',
      build: () {
        when(() => signIn(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignInEvent(email: tEmail, password: tPassword),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() =>
            signIn(const SignInParams(email: tEmail, password: tPassword)));
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when [SingUpEvent] is added',
      build: () {
        when(() => signUp(any()))
            .thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEvent(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        ),
      ),
      expect: () => [const AuthLoading(), const AuthSignedUp()],
      verify: (_) {
        verify(
          () => signUp(
            const SignUpParams(
              email: tEmail,
              password: tPassword,
              fullName: tFullName,
            ),
          ),
        );
      },
    );

    const tServerFailure = ServerFailure(
      message: 'server-error',
      statusCode: 'server is down at the moment try again later',
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when [SingUpEvent] is added',
      build: () {
        when(() => signUp(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignUpEvent(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => signUp(
            const SignUpParams(
              email: tEmail,
              password: tPassword,
              fullName: tFullName,
            ),
          ),
        );
      },
    );
  });

  group('ForgotPassword', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthForgotPasswordSend] '
      'when [ForgotPasswordEvent] is added',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(email: tEmail),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthForgotPasswordSend(),
      ],
      verify: (_) {
        verify(
          () => forgotPassword(
            const ForgotPasswordParams(email: tEmail),
          ),
        );
      },
    );

    const tServerFailure = ServerFailure(
      message: 'user-not-found',
      statusCode: 'There is no user record corresponding to this email',
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      'when [ForgotPasswordEvent] is added',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(email: tEmail),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => forgotPassword(
            const ForgotPasswordParams(email: tEmail),
          ),
        );
      },
    );
  });

  group('UpdateUser', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthUserUpdated] '
      'when [UpdateUserEvent] is added',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const UpdateUserEvent(action: tUpdateUserAction, userData: tEmail),
      ),
      expect: () => [const AuthLoading(), const AuthUserUpdated()],
      verify: (_) {
        verify(
          () => updateUser(
            const UpdateUserParams(
              action: tUpdateUserAction,
              userData: tEmail,
            ),
          ),
        );
      },
    );

    const tServerFailure = ServerFailure(
      message: 'user-not-found',
      statusCode: 'There is no user record corresponding to this id',
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      'when [UpdateUserEvent] is added',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const UpdateUserEvent(action: tUpdateUserAction, userData: tEmail),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => updateUser(
            const UpdateUserParams(
              action: tUpdateUserAction,
              userData: tEmail,
            ),
          ),
        );
      },
    );
  });
}
