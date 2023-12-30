import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  const Failure({required this.message, required this.statusCode});

  final String statusCode;
  final String message;

  @override
  List<Object?> get props => [statusCode, message];
}
