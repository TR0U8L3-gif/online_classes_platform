import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';

class CacheFirstTimer extends UseCase<void, NoParams>{

  CacheFirstTimer({required OnBoardingRepository repository})
      : _repository = repository;
  final OnBoardingRepository _repository;
  @override
  ResultFuture<void> call(NoParams params) {
    return _repository.cacheFirstTimer();
  }
}
