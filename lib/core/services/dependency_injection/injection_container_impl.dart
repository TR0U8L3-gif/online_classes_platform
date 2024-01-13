part of 'injection_container.dart';

/// GetIt Service Locator Instance
final sl = GetIt.instance;

/// Asynchronous function setting up dependency injection
Future<void> setupServiceLocator() async {
  //External
  await _externalInit();
  //Services
  await _servicesInit();
  //Feature - OnBoarding
  await _onBoardingInit();
  //Feature - Auth
  await _authorizationInit();
}

Future<void> _externalInit() async {
  final preferences = await SharedPreferences.getInstance();
  //Dio
  sl.registerLazySingleton(Dio.new);
  //Internet connection checker plus
  sl.registerSingleton(InternetConnection());
  //Shared Preferences
  sl.registerSingleton<SharedPreferences>(
    preferences,
  );
  //FirebaseAuth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  //FirebaseStorage
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  //FirebaseFirestore
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}

Future<void> _servicesInit() async {
  //NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );
}

Future<void> _onBoardingInit() async {
  //Cubit
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      forgotPassword: sl(),
      updateUser: sl(),
    ),
  );
  //UseCase
  sl.registerLazySingleton(() => SignIn(repository: sl()));
  sl.registerLazySingleton(() => SignUp(repository: sl()));
  sl.registerLazySingleton(() => ForgotPassword(repository: sl()));
  sl.registerLazySingleton(() => UpdateUser(repository: sl()));
  //Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  //DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );
}

Future<void> _authorizationInit() async {
  //Bloc
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
