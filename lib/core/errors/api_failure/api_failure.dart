import 'package:online_classes_platform/core/errors/failure.dart';

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

}
