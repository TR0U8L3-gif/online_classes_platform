part of 'on_boarding_cubit.dart';
// OnBoardingStates Route
//
// OnBoardingInitial
// OnBoardingCheckingIfUserIsFirstTimer [yes, no, error]
// OnBoardingUserStatus [yes] -> show on boarding page
// OnBoardingUserStatus [no] -> do sth else
// OnBoardingError [error] -> show onboarding error page
// [yes] OnBoardingUserCached -> cache user after onboarding

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

class OnBoardingInitial extends OnBoardingState {}

class OnBoardingLoading extends OnBoardingState {}

class OnBoardingError extends OnBoardingState {
  const OnBoardingError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class OnBoardingCheckingIfUserIsFirstTimer extends OnBoardingState {}

class OnBoardingUserCached extends OnBoardingState {}

class OnBoardingUserStatus extends OnBoardingState {
  const OnBoardingUserStatus({required this.isFirstTimer});

  final bool isFirstTimer;

  @override
  List<Object> get props => [isFirstTimer];
}
