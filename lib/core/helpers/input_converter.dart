import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:online_classes_platform/core/errors/failure.dart';

class InputConverter {
  static Either<Failure, int> getInt(dynamic data) {
    try {
      switch (data.runtimeType) {
        case String:
          return Right(_stringToInt(data as String));
        case int:
          return Right(data as int);
        case double:
          return Right((data as double).toInt());
        case num:
          return Right((data as num).toInt());
        default:
          return const Left(
            InvalidInputFailure(
              message: 'Invalid input. Please provide a number',
            ),
          );
      }
    } catch (e) {
      return Left(InvalidInputFailure(message: '$e'));
    }
  }

  static Either<Failure, int> getUnsignedInt(dynamic data) {
    const failure = InvalidInputFailure(
      message: 'number must be greater or equal zero',
    );
    try {
      switch (data.runtimeType) {
        case String:
          return Right(_stringToUnsignedInt(data as String));
        case int:
          return (data as int) < 0 ? const Left(failure) : Right(data);
        case double:
          return (data as double).toInt() < 0
              ? const Left(failure)
              : Right(data.toInt());
        case num:
          return (data as num).toInt() < 0
              ? const Left(failure)
              : Right(data.toInt());
        default:
          return const Left(
            InvalidInputFailure(
              message: 'Invalid input. Please provide a number '
                  'that is greater or equal zero',
            ),
          );
      }
    } catch (e) {
      return Left(InvalidInputFailure(message: '$e'));
    }
  }

  static Either<Failure, List<Type>> getList<Type>(dynamic data) {
    try {
      if (data.runtimeType == List) {
        return Right(List<Type>.from(data as List<dynamic>));
      } else {
        return const Left(InvalidInputFailure(
            message: 'Invalid input. Please provide a List'));
      }
    } catch (e) {
      return Left(InvalidInputFailure(message: '$e'));
    }
  }

  static int _stringToUnsignedInt(String str) {
    final number = int.parse(str);

    if (number < 0) {
      throw const InvalidInputException(
        message: 'number must be greater or equal zero',
        statusCode: '',
      );
    }

    return number;
  }

  static int _stringToInt(String str) {
    return int.parse(str);
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
