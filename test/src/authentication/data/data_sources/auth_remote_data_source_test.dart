import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/utils/constants.dart';
import 'package:online_classes_platform/src/authentication/data/data_sources/auth_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: dio);
  });

  group("createUser", () {
    var tResponseSuccess =
        Response(requestOptions: RequestOptions(), data: "", statusCode: 201);
    var tResponseError =
        Response(requestOptions: RequestOptions(), data: "", statusCode: 404);
    const String tPath = "$BASE_URL$USERS_ENDPOINT";

    test(
      'should perform POST request on a URL with correct path',
      () async {
        // arrange
        when(() => dio.post(any(), data: any(named: "data")))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        dataSource.createUser(
            name: "name", avatar: "avatar", createdAt: "createdAt");
        // assert
        verify(() => dio.post(
              tPath,
              data: json.decode(fixture('user/user_model.json')),
            ));
      },
    );

    test(
      'should complete successfully when the status code is 200 or 201',
      () async {
        // arrange
        when(() => dio.post(any(), data: any(named: "data")))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        final methodCall = dataSource.createUser;
        // assert
        expect(
            methodCall(name: "name", avatar: "avatar", createdAt: "createdAt"),
            completes);
        verify(() => dio.post(
              tPath,
              data: json.decode(fixture('user/user_model.json')),
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should throw [ServerException] when the status code is not 200 and 201',
      () async {
        // arrange
        when(() => dio.post(any(), data: any(named: "data")))
            .thenAnswer((invocation) async => Future.value(tResponseError));
        // act
        final methodCall = dataSource.createUser;
        // assert
        expect(
            methodCall(name: "name", avatar: "avatar", createdAt: "createdAt"),
            throwsA(const TypeMatcher<ServerException>()));
        verify(() => dio.post(
              tPath,
              data: json.decode(fixture('user/user_model.json')),
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });

  group("getUser", () {
    var tResponseSuccess = Response(
        requestOptions: RequestOptions(),
        data: json.decode(fixture('user/user.json')),
        statusCode: 200);
    var tResponseError =
        Response(requestOptions: RequestOptions(), data: "", statusCode: 404);
    const String tid = "1";
    const String tPath = "$BASE_URL$USERS_ENDPOINT/$tid";

    test(
      'should perform GET request on a URL with correct path',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        dataSource.getUser(id: tid);
        // assert
        verify(() => dio.get(
              tPath,
            ));
      },
    );

    test(
      'should complete successfully when the status code is 200 or 201',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        final methodCall = dataSource.getUser;
        // assert
        expect(methodCall(id: tid), completes);
        verify(() => dio.get(
              tPath,
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should throw [ServerException] when the status code is not 200 and 201',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseError));
        // act
        final methodCall = dataSource.getUser;
        // assert
        expect(
            methodCall(id: tid), throwsA(const TypeMatcher<ServerException>()));
        verify(() => dio.get(
              tPath,
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });

  group("getUsers", () {
    var tResponseSuccess = Response(
        requestOptions: RequestOptions(),
        data: json.decode(fixture("user/users.json")),
        statusCode: 200);

    var tResponseError =
        Response(requestOptions: RequestOptions(), data: "", statusCode: 404);
    const String tPath = "$BASE_URL$USERS_ENDPOINT";

    test(
      'should perform GET request on a URL with correct path',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        dataSource.getUsers();
        // assert
        verify(() => dio.get(
              tPath,
            ));
      },
    );

    test(
      'should complete successfully when the status code is 200 or 201',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseSuccess));
        // act
        final methodCall = dataSource.getUsers;
        // assert
        expect(methodCall(), completes);
        verify(() => dio.get(
              tPath,
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );

    test(
      'should throw [ServerException] when the status code is not 200 and 201',
      () async {
        // arrange
        when(() => dio.get(any()))
            .thenAnswer((invocation) async => Future.value(tResponseError));
        // act
        final methodCall = dataSource.getUsers;
        // assert
        expect(methodCall(), throwsA(const TypeMatcher<ServerException>()));
        verify(() => dio.get(
              tPath,
            )).called(1);
        verifyNoMoreInteractions(dio);
      },
    );
  });
}
