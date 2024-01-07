import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';

class CheckIfUserIsFirstTimer extends UseCase<bool, UserIsFirstTimerParams> {
  CheckIfUserIsFirstTimer({required OnBoardingRepository repository})
      : _repository = repository;
  final OnBoardingRepository _repository;

  @override
  ResultFuture<bool> call(UserIsFirstTimerParams params) {
    return _repository.checkIfUserIsFirstTimer(userId: params.userId);
  }
}

class UserIsFirstTimerParams extends Equatable {
  const UserIsFirstTimerParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
