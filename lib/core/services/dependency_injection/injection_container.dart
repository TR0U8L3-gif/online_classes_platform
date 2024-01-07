import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';


/// GetIt Service Locator Instance
final sl = GetIt.instance;

/// Asynchronous function setting up dependency injection
Future<void> setupServiceLocator() async {
  //Src
  //Cubit
  //UseCase
  //Repository
  //DataSource

  //Services
  //NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()),
    );

  //External
  //Dio
  sl.registerLazySingleton(Dio.new);
  //Internet connection checker plus
  sl.registerSingleton(InternetConnection());
}
