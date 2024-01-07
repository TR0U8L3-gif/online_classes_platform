import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/errors/failure.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/cache_first_timer.dart';

import 'mock_on_boarding_repository.mock.dart';

void main() {
  late OnBoardingRepository repository;
  late CacheFirstTimer useCase;

  setUp(() {
    repository = MockOnBoardingRepository();
    useCase = CacheFirstTimer(repository: repository);
  });

  const tResponseSuccessful = null;
  const tResponseFailure = ServerFailure(
    message: 'message',
    statusCode: 500,
  );

  test(
    'should call [OnBoardingRepository.cacheFirstTimer] '
    'and return successful response',
    () async {
      // arrange
      when(() => repository.cacheFirstTimer())
          .thenAnswer((invocation) async => const Right(tResponseSuccessful));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Right<Failure, void>(tResponseSuccessful));
      verify(() => repository.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'should call [OnBoardingRepository.cacheFirstTimer] '
    'and return unsuccessful response',
    () async {
      // arrange
      when(() => repository.cacheFirstTimer())
          .thenAnswer((invocation) async => const Left(tResponseFailure));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Left<Failure, void>(tResponseFailure));
      verify(() => repository.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
