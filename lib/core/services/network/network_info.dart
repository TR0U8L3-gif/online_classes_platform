import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {

  NetworkInfoImpl({required this.internetConnectionChecker});
  final InternetConnectionChecker internetConnectionChecker;

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}