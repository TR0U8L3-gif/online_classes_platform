import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:online_classes_platform/core/errors/failure.dart';

class InputConverter {
  static Either<Failure, int> stringToUnsignedInt(String str) {
    final number = int.tryParse(str);

    if (number == null || number < 0) {
      return const Left(
        InvalidInputFailure(
          message: 'Invalid input. Please provide a integer greater than '
              'or equal to zero.',
        ),
      );
    }

    return Right(number);
  }

  static Either<Failure, int> stringToInt(String str) {
    final number = int.tryParse(str);
    if (number == null) {
      return const Left(
        InvalidInputFailure(
          message: 'Invalid input. Please provide a integer.',
        ),
      );
    }
    return Right(number);
  }

  static Either<Failure, List<T>> stringToList<T>(String str) {
    final List<T> list;
    try {
      list = List<T>.from(jsonDecode(str) as List);
    } catch (e) {
      return Left(
        InvalidInputFailure(
          message: '$e',
        ),
      );
    }
    return Right(list);
  }
}
