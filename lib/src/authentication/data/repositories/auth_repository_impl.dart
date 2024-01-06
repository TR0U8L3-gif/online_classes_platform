import 'package:dartz/dartz.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';
import 'package:online_classes_platform/src/authentication/domain/repositories/auth_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _networkInfo = networkInfo,
        _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<void> createUser({
      required String name,
      required String avatar,
      required String createdAt,
      }) {
    return _checkInternetAndGetData<void>(() => _remoteDataSource.createUser(
          name: name,
          avatar: avatar,
          createdAt: createdAt,
        ));
  }

  @override
  ResultFuture<User> getUser({required String id}) {
    return _checkInternetAndGetData(() => _remoteDataSource.getUser(id: id));
  }

  @override
  ResultFuture<List<User>> getUsers() {
    return _checkInternetAndGetData(() => _remoteDataSource.getUsers());
  }

  ResultFuture<Type> _checkInternetAndGetData<Type>(
      Future<Type> Function() function) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await function();
        return Right(result);
      } on ServerException catch (se) {
        return Left(ServerFailure.fromException(serverException: se));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
