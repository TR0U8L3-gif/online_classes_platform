import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/config/assets/assets.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/utils/constants.dart';
import 'package:online_classes_platform/core/utils/enums/update_user.dart';
import 'package:online_classes_platform/src/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'uid';

  set uid(String uid) => _uid = uid;

  @override
  String get uid => _uid;
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  set user(User? user) => _user = user;

  @override
  User? get user => _user;
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth auth;
  late MockFirebaseStorage storage;
  late FirebaseFirestore firestore;
  late AuthRemoteDataSource dataSource;

  late User mockUser;
  late UserCredential mockUserCredential;
  late DocumentReference<Map<String, dynamic>> documentReference;

  const tPassword = 'password';
  const tFullName = 'fullName';
  const tEmail = 'email@domain.com';
  const tUser = LocalUserModel(
    uid: 'uid',
    email: tEmail,
    points: 0,
    fullName: tFullName,
  );

  setUpAll(() async {
    auth = MockFirebaseAuth();
    storage = MockFirebaseStorage();
    firestore = FakeFirebaseFirestore();
    dataSource = AuthRemoteDataSourceImpl(
      auth: auth,
      firestore: firestore,
      storage: storage,
    );

    //Creating User with valid uid
    documentReference = firestore.collection('users').doc();

    mockUser = MockUser()..uid = documentReference.id;
    mockUserCredential = MockUserCredential(mockUser);

    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );

    //Returning valid User from FirebaseAuth
    when(() => auth.currentUser).thenReturn(mockUser);
  });

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'no user record',
  );

  group('forgotPassword', () {
    test(
      'should complete successfully when no Exception is thrown',
      () async {
        // arrange
        when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
            .thenAnswer((invocation) async => Future.value());
        // act
        final call = dataSource.forgotPassword(email: tEmail);
        // assert
        expect(call, completes);
        verify(() => auth.sendPasswordResetEmail(email: tEmail)).called(1);
        verifyNoMoreInteractions(auth);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseException] is thrown',
      () async {
        // arrange
        when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
            .thenThrow(tFirebaseAuthException);
        // act
        final call = dataSource.forgotPassword(email: tEmail);
        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(() => auth.sendPasswordResetEmail(email: tEmail)).called(1);
        verifyNoMoreInteractions(auth);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        // arrange
        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((invocation) async => mockUserCredential);
        // act
        final result =
            await dataSource.signIn(email: tEmail, password: tPassword);
        // assert
        expect(result.uid, mockUserCredential.user!.uid);
        verify(
          () => auth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(auth);
      },
    );

    test(
      'should throw [ServerException] when uiser is null after signing in',
      () async {
        // arrange
        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (invocation) async => MockUserCredential(),
        );
        // act
        final call = dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );
        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(
          () => auth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(auth);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseException] is thrown',
      () async {
        // arrange
        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);
        // act
        final call = dataSource.signIn(email: tEmail, password: tPassword);
        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(
          () => auth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(auth);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no exception is thrown',
      () async {
        // arrange
        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((invocation) async => mockUserCredential);
        when(() => mockUserCredential.user?.updateDisplayName(any()))
            .thenAnswer((invocation) async => Future.value());
        when(() => mockUserCredential.user?.updatePhotoURL(any()))
            .thenAnswer((invocation) async => Future.value());
        // act
        final call = dataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        // assert
        expect(call, completes);
        verify(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);

        await untilCalled(
          () => mockUserCredential.user?.updateDisplayName(
            any(),
          ),
        );
        await untilCalled(
          () => mockUserCredential.user?.updatePhotoURL(
            any(),
          ),
        );

        verify(() => mockUserCredential.user?.updateDisplayName(tFullName))
            .called(1);
        verify(() => mockUserCredential.user?.updatePhotoURL(kDefaultAvatarUrl))
            .called(1);

        verifyNoMoreInteractions(auth);
      },
    );
    test(
      'should throw [ServerException] when [FirebaseException] is thrown',
      () async {
        // arrange
        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);
        // act
        final call = dataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );
        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(
          () => auth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(auth);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });

    test(
      'should update user fullName when no [Exception] is thrown',
      () async {
        // arrange
        when(() => mockUser.updateDisplayName(any()))
            .thenAnswer((invocation) => Future.value());
        // act
        await dataSource.updateUser(
          action: UpdateUserAction.fullName,
          userData: tFullName,
        );

        final userData =
            await firestore.collection('users').doc(mockUser.uid).get();
        // assert
        expect(userData.data()!['fullName'], tFullName);
        verify(() => mockUser.updateDisplayName(tFullName)).called(1);
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateEmail(any()));
      },
    );

    test(
      'should update user email when no [Exception] is thrown',
      () async {
        // arrange
        when(() => mockUser.updateEmail(any()))
            .thenAnswer((invocation) => Future.value());
        // act
        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        final userData =
            await firestore.collection('users').doc(mockUser.uid).get();
        // assert
        expect(userData.data()!['email'], tEmail);
        verify(() => mockUser.updateEmail(tEmail)).called(1);
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));
      },
    );

    test(
      'should update user bio when no [Exception] is thrown',
      () async {
        // arrange
        const newBio = 'bio';
        // act
        await dataSource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );

        final userData =
            await firestore.collection('users').doc(mockUser.uid).get();
        // assert
        expect(userData.data()!['bio'], newBio);
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));
      },
    );

    test(
      'should update user password when no [Exception] is thrown',
      () async {
        // arrange
        when(() => mockUser.updatePassword(any())).thenAnswer(
          (invocation) async => Future.value(),
        );
        when(() => mockUser.reauthenticateWithCredential(any()))
            .thenAnswer((invocation) async => mockUserCredential);

        when(() => mockUser.email).thenReturn(tEmail);
        // act
        await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          }),
        );
        final userData =
            await firestore.collection('users').doc(mockUser.uid).get();
        // assert
        expect(userData.data()!['password'], null);
        verify(() => mockUser.updatePassword(tPassword));
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));
      },
    );

    test(
      'should update profilePhotoUrl when no [Exception] is thrown',
      () async {
        // arrange
        final newProfilePhotoUrl = File(Assets.imagesOnBoardingBackground);

        when(() => mockUser.updatePhotoURL(any()))
            .thenAnswer((invocation) async => Future.value());
        // act
        await dataSource.updateUser(
          action: UpdateUserAction.profilePhotoUrl,
          userData: newProfilePhotoUrl,
        );
        // assert
        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));

        expect(storage.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
