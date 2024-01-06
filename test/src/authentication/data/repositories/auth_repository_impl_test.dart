import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';
import 'package:online_classes_platform/src/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:online_classes_platform/src/authentication/data/models/user_model.dart';
import 'package:online_classes_platform/src/authentication/data/repositories/auth_repository_impl.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(() => networkInfo.isConnected)
            .thenAnswer((invocation) async => true);
      });
      body();
    });
  }

  group("createUser", () {
    var name = 'name';
    var avatar = 'avatar';
    var createdAt = 'createdAt';
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => remoteDataSource.createUser(
                name: any(named: "name"), avatar: any(named: "avatar"), createdAt: any(named: 'createdAt')))
            .thenAnswer((_) async => Future.value(null));
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.createUser(
            name: name, avatar: avatar, createdAt: createdAt);
        // assert
        verify(() => networkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source is successful',
        () async {
          // arrange
          when(() => remoteDataSource.createUser(
                name: any(named: "name"),
                avatar: any(named: "avatar"),
                createdAt: any(named: "createdAt"),
              )).thenAnswer((invocation) async => Future.value());
          // act
          final result = await repository.createUser(
            name: name,
            avatar: avatar,
            createdAt: createdAt,
          );
          // assert
          expect(result, equals(const Right(null)));
          verify(() => remoteDataSource.createUser(
                name: name,
                avatar: avatar,
                createdAt: createdAt,
              ));
        },
      );

      test(
        'should return a ServerFailure when the call to the remote source is unsuccessful',
        () async {
          var message = "Unknown Error";
          var statusCode = "500";
          // arrange
          when(() => remoteDataSource.createUser(
                name: any(named: "name"),
                avatar: any(named: "avatar"),
                createdAt: any(named: "createdAt"),
              )).thenThrow(ServerException(
            message: message,
            statusCode: statusCode,
          ));
          // act
          final result = await repository.createUser(
            name: name,
            avatar: avatar,
            createdAt: createdAt,
          );
          // assert
          expect(
              result,
              Left(ServerFailure(
                message: message,
                statusCode: statusCode,
              )));
          verify(() => remoteDataSource.createUser(
                name: name,
                avatar: avatar,
                createdAt: createdAt,
              )).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    });
  });

  group("getUser", () {
    String tid = "tid";
    UserModel tUserModel = const UserModel(
      id: "id",
      name: "name",
      avatar: "avatar",
      createdAt: "createdAt",
    );
    User tUser = tUserModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => remoteDataSource.getUser(id: any(named: "id")))
            .thenAnswer((_) async => Future.value(tUserModel));
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getUser(id: tid);
        // assert
        verify(() => networkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should call the [RemoteDataSource.getUser] and complete '
        'successfully when the call to the remote source is successful',
        () async {
          // arrange
          when(() => remoteDataSource.getUser(id: any(named: "id")))
              .thenAnswer((invocation) async => Future.value(tUserModel));
          // act
          final result = await repository.getUser(id: tid);
          // assert
          expect(result, equals( Right(tUser)));
            verify(() => remoteDataSource.getUser(id: tid));
        },
      );

      test(
        'should return a ServerFailure when the call to the remote source is unsuccessful',
        () async {
          var message = "Unknown Error";
          var statusCode = "500";
          // arrange
          when(() => remoteDataSource.getUser(id: any(named: "id")))
              .thenThrow(
                  ServerException(message: message, statusCode: statusCode));
          // act
          final result = await repository.getUser(id: tid);
          // assert
          expect(result,
              Left(ServerFailure(message: message, statusCode: statusCode)));
        },
      );
    });
  });

  group("getUsers", () {

    var tUserModelList = <UserModel>[];
    List<User> tUserList = tUserModelList;

    test(
      'should check if the device is online',
          () async {
        // arrange
        when(() => remoteDataSource.getUsers())
            .thenAnswer((_) async => Future.value(tUserModelList));
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getUsers();
        // assert
        verify(() => networkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should call the [RemoteDataSource.getUsers] and complete '
            'successfully when the call to the remote source is successful',
            () async {
          // arrange
          when(() => remoteDataSource.getUsers())
              .thenAnswer((invocation) async => Future.value(tUserModelList));
          // act
          final result = await repository.getUsers();
          // assert
          expect(result, equals( Right(tUserList)));
          verify(() => remoteDataSource.getUsers());
        },
      );

      test(
        'should return a ServerFailure when the call to the remote source is unsuccessful',
            () async {
          var message = "Unknown Error";
          var statusCode = "500";
          // arrange
          when(() => remoteDataSource.getUsers())
              .thenThrow(
              ServerException(message: message, statusCode: statusCode));
          // act
          final result = await repository.getUsers();
          // assert
          expect(result,
              Left(ServerFailure(message: message, statusCode: statusCode)));
        },
      );
    });
  });
}
