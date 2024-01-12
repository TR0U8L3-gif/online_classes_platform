import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/helpers/input_converter.dart';

void main() {
  group('getUnsignedInt', () {
    test(
      'should return an integer when string represent unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = InputConverter.getUnsignedInt(str);
        // assert
        expect(result, const Right<Failure, dynamic>(123));
      },
    );

    test(
      'should return Failure when string is not an int',
      () async {
        // arrange
        const str = '-a123';
        // act
        final result = InputConverter.getUnsignedInt(str);
        // assert
        expect(
          (result as Left).value,
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should return Failure when string is a negative int',
      () async {
        // arrange
        const str = '-123';
        // act
        final result = InputConverter.getUnsignedInt(str);
        // assert
        expect(
          (result as Left).value,
          isA<InvalidInputFailure>(),
        );
      },
    );
  });

  group('getInt', () {
    test(
      'should return an integer when string represent unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = InputConverter.getInt(str);
        // assert
        expect(result, const Right<Failure, dynamic>(123));
      },
    );

    test(
      'should return Failure when string is not an int',
      () async {
        // arrange
        const str = '-a123';
        // act
        final result = InputConverter.getInt(str);
        // assert
        expect(
          (result as Left).value,
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should return an integer when string is a negative int',
      () async {
        // arrange
        const str = '-123';
        // act
        final result = InputConverter.getInt(str);
        // assert
        expect(result, const Right<Failure, dynamic>(-123));
      },
    );
  });

  group('stringToList<int>', () {
    test(
      'should return a list of integers '
      'when string represents a list of integers',
      () async {
        // arrange
        const str = '[123, -123]';
        // act
        final result = InputConverter.stringToList<int>(str);
        // assert
        expect((result as Right).value, [123, -123]);
      },
    );

    test(
      'should return Failure when string is not a list of integers',
      () async {
        // arrange
        const str = '[-a123]';
        // act
        final result = InputConverter.stringToList<int>(str);
        // assert
        expect(
          (result as Left).value,
          isA<InvalidInputFailure>(),
        );
      },
    );

    test(
      'should return Failure when string is a negative int',
      () async {
        // arrange
        const str = '-123';
        // act
        final result = InputConverter.stringToList<int>(str);
        // assert
        expect(
          (result as Left).value,
          isA<InvalidInputFailure>(),
        );
      },
    );
  });
}
