import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
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

void main() {
  late FirebaseAuth auth;
  late FirebaseStorage storage;
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
    // when(() => auth.currentUser).thenReturn(mockUser);
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
  });
}
