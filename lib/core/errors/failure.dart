import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode}) :
  assert(
    statusCode is String || statusCode is int,
    "StatusCode Type must be a 'String' or 'int'",
  );

  factory Failure.fromException({
    required Failure serverException,
  }) {
    return ServerFailure(
      message: serverException.message,
      statusCode: serverException.statusCode,
    );
  }

  final String message;
  final dynamic statusCode;

  String get errorMessage => '$statusCode Error: $message';

  @override
  List<Object?> get props => [statusCode, message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});
}

class CacheFailure extends Failure{
  const CacheFailure({required super.message, required super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super(
          message: 'No Internet Connection',
          statusCode: '503',
        );
}
