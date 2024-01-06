import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/src/authentication/data/models/user_model.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';
import 'package:online_classes_platform/src/authentication/domain/usecases/create_user.dart';
import 'package:online_classes_platform/src/authentication/domain/usecases/get_user.dart';
import 'package:online_classes_platform/src/authentication/domain/usecases/get_users.dart';
import 'package:online_classes_platform/src/authentication/presentation/cubit/auth_cubit.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUser extends Mock implements GetUser {}

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUser getUser;
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthCubit cubit;

  setUp(() {
    getUser = MockGetUser();
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthCubit(
      getUser: getUser,
      getUsers: getUsers,
      createUser: createUser,
    );
  });

  tearDown(() => cubit.close());

  test(
    'should check if initial state is [AuthInitial]',
    () async {
      // assert
      expect(cubit.state, const AuthInitial());
    },
  );

  group("createUser", () {
    final tCreateUserParams = CreateUserParams(
      name: "name",
      avatar: "avatar",
      createdAt: "createdAt",
    );
    const tServerFailure =
        ServerFailure(message: "message", statusCode: "statusCode");

    setUp(() => registerFallbackValue(tCreateUserParams));

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthCreatingUser, AuthUserCreated] when successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((invocation) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: "name",
        avatar: "avatar",
        createdAt: "createdAt",
      ),
      expect: () => <AuthState>[
        const AuthCreatingUser(),
        const AuthUserCreated(),
      ],
      verify: (cubit) => createUser(tCreateUserParams),
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthCreatingUser, AuthError] when unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        name: "name",
        avatar: "avatar",
        createdAt: "createdAt",
      ),
      expect: () => <AuthState>[
        const AuthCreatingUser(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (cubit) => createUser(tCreateUserParams),
    );
  });

  group("getUser", () {
    const tGetUserParams = GetUserParams(
      id: "id",
    );
    const tServerFailure =
        ServerFailure(message: "message", statusCode: "statusCode");
    final User tUser = UserModel.fromJson(fixture("user/user.json"));

    setUp(() => registerFallbackValue(tGetUserParams));

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthGettingUser, AuthUserLoaded] when successful',
      build: () {
        when(() => getUser(any()))
            .thenAnswer((invocation) async => Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.getUser(
        id: "id",
      ),
      expect: () => <AuthState>[
        const AuthGettingUser(),
        AuthUserLoaded(user: tUser),
      ],
      verify: (cubit) => getUser(tGetUserParams),
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthGettingUser, AuthError] when unsuccessful',
      build: () {
        when(() => getUser(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUser(
        id: "id",
      ),
      expect: () => <AuthState>[
        const AuthGettingUser(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (cubit) => getUser(tGetUserParams),
    );
  });

  group("getUsers", () {
    final tGetUsersParams = NoParams();
    const tServerFailure =
        ServerFailure(message: "message", statusCode: "statusCode");
    final List<User> tUsersList = List<Map<String,dynamic>>.from(jsonDecode(fixture('user/users.json'))).map((userData) => UserModel.fromMap(userData)).toList();

    setUp(() => registerFallbackValue(tGetUsersParams));

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthGettingUsers, AuthUsersLoaded] when successful',
      build: () {
        when(() => getUsers(any()))
            .thenAnswer((invocation) async => Right(tUsersList));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthState>[
        const AuthGettingUsers(),
        AuthUsersLoaded(users: tUsersList),
      ],
      verify: (cubit) => getUsers(tGetUsersParams),
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthGettingUsers, AuthError] when unsuccessful',
      build: () {
        when(() => getUsers(any()))
            .thenAnswer((invocation) async => const Left(tServerFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthState>[
        const AuthGettingUsers(),
        AuthError(message: tServerFailure.errorMessage),
      ],
      verify: (cubit) => getUsers(tGetUsersParams),
    );
  });
}
