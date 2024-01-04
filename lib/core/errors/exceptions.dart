import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String statusCode;
  final String message;
  const ServerException({required this.message, required this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];

}