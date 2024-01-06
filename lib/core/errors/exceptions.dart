import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});
  final String statusCode;
  final String message;
  @override
  List<Object?> get props => [message, statusCode];

}