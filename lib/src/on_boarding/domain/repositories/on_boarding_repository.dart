import 'package:online_classes_platform/core/utils/typedef.dart';

abstract class OnBoardingRepository {
  ResultFuture<void> cacheFirstTimer();
  ResultFuture<bool> checkIfUserIsFirstTimer({required String userId});

}
