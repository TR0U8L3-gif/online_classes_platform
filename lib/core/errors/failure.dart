import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode})
      : assert(
          statusCode is String || statusCode is int,
          "StatusCode Type must be a 'String' or 'int'",
        );

  Failure.fromException({
    required AppException exception,
  })  : message = exception.message,
        statusCode = exception.statusCode;

  final String message;
  final dynamic statusCode;

  String get errorMessage =>
      '$statusCode ${statusCode is String ? '' : 'Error'}: $message';

  @override
  List<Object?> get props => [statusCode, message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException({
    required super.exception,
  }) : super.fromException();
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});

  CacheFailure.fromException({
    required super.exception,
  }) : super.fromException();
}

class NetworkFailure extends Failure {
  const NetworkFailure({String? message})
      : super(
          message: message ?? 'No Internet Connection',
          statusCode: 503,
        );

  NetworkFailure.fromException({
    required super.exception,
  }) : super.fromException();
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.statusCode = 400});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required super.message, super.statusCode = 400});
}
