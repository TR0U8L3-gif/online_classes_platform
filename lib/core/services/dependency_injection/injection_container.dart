import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';
import 'package:online_classes_platform/src/on_boarding/data/data_sources/on_boarding_local_data_source.dart';
import 'package:online_classes_platform/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/cache_first_timer.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/check_if_user_is_first_timer.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// GetIt Service Locator Instance
final sl = GetIt.instance;

/// Asynchronous function setting up dependency injection
Future<void> setupServiceLocator() async {
  final preferences = await SharedPreferences.getInstance();

  //External
  //Dio
  sl.registerLazySingleton(Dio.new);
  //Internet connection checker plus
  sl.registerSingleton(InternetConnection());
  //Shared Preferences
  sl.registerSingleton<SharedPreferences>(
    preferences,
  );

  //Services
  //NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );

  //Feature - OnBoarding
  //Cubit
  sl.registerFactory(
    () => OnBoardingCubit(
      cacheFirstTimer: sl(),
      checkIfUserIsFirstTimer: sl(),
    ),
  );
  //UseCase
  sl.registerLazySingleton(
    () => CacheFirstTimer(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CheckIfUserIsFirstTimer(
      repository: sl(),
    ),
  );
  //Repository
  sl.registerLazySingleton<OnBoardingRepository>(
    () => OnBoardingRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  //DataSource
  sl.registerLazySingleton<OnBoardingLocalDataSource>(
    () => OnBoardingLocalDataSourceImpl(
        preferences: sl(),
    ),
  );
}
