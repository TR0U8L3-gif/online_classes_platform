import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/src/authentication/domain/entities/user.dart';
import 'package:online_classes_platform/src/authentication/domain/repositories/auth_repository.dart';
import 'package:online_classes_platform/src/authentication/domain/usecases/get_users.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUsers useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test(
    'should call repository getUsers()',
        () async {
      // arrange
      when(() => repository.getUsers()).thenAnswer((_) async => const Right(tResponse));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Right(tResponse));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );


}