import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnection {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
        internetConnectionChecker: mockInternetConnectionChecker);
  });

  group('is connected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnection = Future.value(true);
        when(() => mockInternetConnectionChecker.hasInternetAccess)
            .thenAnswer((invocation) => tHasConnection);
        // act
        final result = networkInfoImpl.isConnected;
        // assert
        verify(() => mockInternetConnectionChecker.hasInternetAccess);
        expect(result, tHasConnection);
      },
    );
  });
}
