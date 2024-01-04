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

    if(response.statusCode == 200 || response.statusCode == 201){
      return;
    } else {
      throw ServerException(message: 'Unable to create user: ${response.statusMessage}', statusCode: "${response.statusCode}");
    }
  }

  @override
  Future<UserModel> getUser({required String id}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }
}
