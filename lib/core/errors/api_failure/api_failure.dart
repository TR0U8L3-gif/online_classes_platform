import '../failure.dart';

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

}
