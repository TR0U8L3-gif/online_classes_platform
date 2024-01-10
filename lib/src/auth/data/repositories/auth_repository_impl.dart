import 'package:dartz/dartz.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';
import 'package:online_classes_platform/core/utils/enums/update_user.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:online_classes_platform/src/auth/domain/entities/local_user.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource dataSource,
    required NetworkInfo networkInfo,
  })  : _dataSource = dataSource,
        _networkInfo = networkInfo;

  final AuthRemoteDataSource _dataSource;
  final NetworkInfo _networkInfo;

  @override
  ResultFuture<void> forgotPassword({required String email}) {
    return _getResultOrFailure(
      () => _dataSource.forgotPassword(email: email),
    );
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) {
    return _getResultOrFailure(
      () => _dataSource.signIn(email: email, password: password),
    );
  }

  @override
  ResultFuture<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _getResultOrFailure(
      () => _dataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) {
    return _getResultOrFailure<void>(
      () => _dataSource.updateUser(
        action: action,
        userData: userData,
      ),
    );
  }

  ResultFuture<Type> _getResultOrFailure<Type>(
    Future<Type> Function() function,
  ) async {
    try {
      final connection = await _networkInfo.isConnected;
      if (!connection) return const Left(NetworkFailure());
    } catch (e) {
      return Left(NetworkFailure(message: 'No Internet Connection $e'));
    }
    try {
      final result = await function();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(exception: e));
    } catch (e, s) {
      return Left(
        UnknownFailure(
          message: '$e',
          statusCode: '$s',
        ),
      );
    }
  }
}
