import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String statusCode;
  final String message;

  String get errorMessage => '$statusCode Error: $message';

  @override
  List<Object?> get props => [statusCode, message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});
  factory ServerFailure.fromException({required ServerException serverException}) {
    return ServerFailure(
      message: serverException.message,
      statusCode: serverException.statusCode,
    );
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'No Internet Connection', statusCode: '503');
}
