import 'package:online_classes_platform/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource {
  Future<void> cacheFirstTimer();

  Future<bool> checkIfUserIsFirstTimer({required String userId});
}
const kFirstTimerKey = 'first_timer';

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  OnBoardingLocalDataSourceImpl({required SharedPreferences preferences})
      : _preferences = preferences;

  final SharedPreferences _preferences;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _preferences.setBool(kFirstTimerKey, false);
    } catch (e) {
      throw CacheException(message: '$e', statusCode: '500');
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer({required String userId}) async {
    try {
      final result = _preferences.getBool(kFirstTimerKey);
      return result ?? true;
    } catch (e) {
      throw CacheException(message: '$e', statusCode: '500');
    }
  }
}
