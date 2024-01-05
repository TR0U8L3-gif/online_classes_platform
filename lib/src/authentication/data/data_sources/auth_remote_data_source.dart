import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:online_classes_platform/core/utils/constants.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String name,
    required String avatar,
    required String createdAt,
  });

  Future<UserModel> getUser({required String id});

  Future<List<UserModel>> getUsers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<void> createUser(
      {required String name,
      required String avatar,
      required String createdAt}) async {
    Response response = await _dio.post("$BASE_URL$USERS_ENDPOINT", data: {
      "name": name,
      "avatar": avatar,
      "createdAt": createdAt,
    });

    try {
      _isResponseSuccessful(
          response,
          ServerException(
            message: 'Unable to create user: ${response.statusMessage}',
            statusCode: "${response.statusCode}",
          ),
          [200, 201]);
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser({required String id}) async {
    Response response = await _dio.get("$BASE_URL$USERS_ENDPOINT/$id");

    try {
      _isResponseSuccessful(
          response,
          ServerException(
            message: 'Unable to get user: ${response.statusMessage}',
            statusCode: "${response.statusCode}",
          ),
          [200, 201]);
      return UserModel.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    Response response =
        await _dio.get("$BASE_URL$USERS_ENDPOINT");
    try {
      _isResponseSuccessful(
          response,
          ServerException(
            message: 'Unable to get users: ${response.statusMessage}',
            statusCode: "${response.statusCode}",
          ),
          [200, 201]);
      return List<Map<String, dynamic>>.from(response.data as List)
          .map((data) => UserModel.fromMap(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  void _isResponseSuccessful(Response response, ServerException exception,
      List<int> successfulStatusCodes) {
    if (successfulStatusCodes.contains(response.statusCode)) {
      return;
    } else {
      throw exception;
    }
  }
}
