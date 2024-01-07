import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/check_if_user_is_first_timer.dart';

import 'mock_on_boarding_repository.mock.dart';

void main() {
  late OnBoardingRepository repository;
  late CheckIfUserIsFirstTimer useCase;

  setUp(() {
    repository = MockOnBoardingRepository();
    useCase = CheckIfUserIsFirstTimer(repository: repository);
  });

  const tUserId = '1';
  const tResponseSuccessful = true;
  const tResponseFailure = ServerFailure(
    message: 'message',
    statusCode: 500,
  );

  test(
    'should call [OnBoardingRepository.checkIfUserIsFirstTimer] '
    'and return successful response',
    () async {
      // arrange
      when(
        () => repository.checkIfUserIsFirstTimer(userId: any(named: 'userId')),
      ).thenAnswer((invocation) async => const Right(tResponseSuccessful));
      // act
      final result =
          await useCase(const UserIsFirstTimerParams(userId: tUserId));
      // assert
      expect(result, const Right<Failure, bool>(tResponseSuccessful));
      verify(() => repository.checkIfUserIsFirstTimer(userId: tUserId))
          .called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should call [OnBoardingRepository.checkIfUserIsFirstTimer] '
    'and return unsuccessful response',
    () async {
      // arrange
      when(
        () => repository.checkIfUserIsFirstTimer(userId: any(named: 'userId')),
      ).thenAnswer((invocation) async => const Left(tResponseFailure));
      // act
      final result =
          await useCase(const UserIsFirstTimerParams(userId: tUserId));
      // assert
      expect(result, const Left<Failure, void>(tResponseFailure));
      verify(() => repository.checkIfUserIsFirstTimer(userId: tUserId))
          .called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
