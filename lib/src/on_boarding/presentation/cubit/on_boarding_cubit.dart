import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/usecase/usecase.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/cache_first_timer.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/check_if_user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;

  Future<void> cacheFirstTimer() async {
    final result = await _cacheFirstTimer(
      NoParams(),
    );

    result.fold(
      (l) => emit(
        OnBoardingError(
          message: l.errorMessage,
        ),
      ),
      (r) => emit(OnBoardingUserCached()),
    );
  }

  Future<void> checkIfUserIsFirstTimer() async {
    final result = await _checkIfUserIsFirstTimer(
      const UserIsFirstTimerParams(
        userId: '',
      ),
    );
    result.fold(
      (l) => emit(const OnBoardingUserStatus(isFirstTimer: true)),
      (r) => emit(OnBoardingUserStatus(isFirstTimer: r)),
    );
  }
}
