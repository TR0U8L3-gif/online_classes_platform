import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/utils/constants.dart';
import 'package:online_classes_platform/core/utils/enums/update_user.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: '$e', statusCode: '503');
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, email);

      userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: '$e', statusCode: '503');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.updatePhotoURL(kDefaultAvatarUrl);

      await _setUserData(userCredential.user!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: '$e', statusCode: '503');
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _auth.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.fullName:
          await _auth.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.profilePhotoUrl:
          final ref = _storage.ref().child(
                'profile_photo/${_auth.currentUser?.uid}',
              );
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _auth.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePhotoUrl': url});
        case UpdateUserAction.password:
          if (_auth.currentUser?.email == null) {
            throw const ServerException(
              message: 'User does not exist',
              statusCode: '401',
            );
          } else {
            final newData =
                jsonDecode(userData as String) as Map<String, dynamic>;
            await _auth.currentUser?.reauthenticateWithCredential(
              EmailAuthProvider.credential(
                email: _auth.currentUser!.email!,
                password: newData['oldPassword'] as String,
              ),
            );
            await _auth.currentUser
                ?.updatePassword(newData['newPassword'] as String);
          }
        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData});
        case UpdateUserAction.points:
        // TODO(UpdateUserAction): Handle this case.
        case UpdateUserAction.groupsId:
        // TODO(UpdateUserAction): Handle this case.
        case UpdateUserAction.enrolledCourses:
        // TODO(UpdateUserAction): Handle this case.
        case UpdateUserAction.following:
        // TODO(UpdateUserAction): Handle this case.
        case UpdateUserAction.followers:
        // TODO(UpdateUserAction): Handle this case.
      }
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? '', statusCode: e.code);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData(
    String uid,
  ) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(
    User user,
    String fallbackEmail,
  ) async {
    return _firestore.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            profilePhotoUrl: user.photoURL ?? '',
            points: 0,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .update(data);
  }
}
