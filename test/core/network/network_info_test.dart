import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfo networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();

    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward call to DataConnectionChecker.hasConnection',
      () async {
        // arrange
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((realInvocation) async => true);

        // act
        final result = await networkInfoImpl.isConnected;

        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, true);
      },
    );
  });
}
