import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/src/authentication/domain/repositories/auth_repository.dart';
import 'package:online_classes_platform/src/authentication/domain/usecases/create_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CreateUser useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = CreateUser(repository);
  });

  final params = Params.empty();

  test(
    'should call repository createUser()',
    () async {
      // arrange
      when(() => repository.createUser(
            name: any(named: "name"),
            avatar: any(named: "avatar"),
            createdAt: any(named: "createdAt"),
          )).thenAnswer((_) async => const Right(null));
      // act
      final result = await useCase(params);
      // assert
      expect(result, const Right(null));
      verify(() => repository.createUser(
            name: params.name,
            avatar: params.avatar,
            createdAt: params.createdAt,
          )).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
