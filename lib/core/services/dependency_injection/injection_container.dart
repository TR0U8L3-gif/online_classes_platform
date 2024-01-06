import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/services/network/network_info.dart';
import '../../../src/authentication/data/data_sources/auth_remote_data_source.dart';
import '../../../src/authentication/data/repositories/auth_repository_impl.dart';
import '../../../src/authentication/domain/repositories/auth_repository.dart';
import '../../../src/authentication/domain/usecases/create_user.dart';
import '../../../src/authentication/domain/usecases/get_user.dart';
import '../../../src/authentication/domain/usecases/get_users.dart';
import '../../../src/authentication/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {

  //Src - authentication feature
  //Cubit
  sl.registerFactory(() => AuthCubit(getUser: sl(), getUsers: sl(), createUser: sl()));
  //UseCase
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetUser(sl()));
  sl.registerLazySingleton(() => GetUsers(sl()));
  //Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  //DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));

  //Services
  //NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: sl()));

  //External
  //Dio
  sl.registerLazySingleton(() => Dio());
  //Internet connection checker
  sl.registerSingleton(InternetConnectionChecker());

}