import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failures.dart';
import 'package:flutter_tdd_clean_architecture/core/network/network_info.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_tirivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: testNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
        // act
        repository.getConcreteNumberTrivia(testNumber);

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          // act
          final _result = await repository.getConcreteNumberTrivia(testNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          expect(_result, equals(Right(tNumberTriviaModel)));
        },
      );

      test(
        'should cache the data localy when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          // act
          final _result = await repository.getConcreteNumberTrivia(testNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          // act
          final _result = await repository.getConcreteNumberTrivia(testNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(_result, equals(Left(ServerFailures())));
        },
      );

      //
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final _result = await repository.getConcreteNumberTrivia(testNumber);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(_result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final _result = await repository.getConcreteNumberTrivia(testNumber);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(_result, equals(Left(CacheFailures())));
        },
      );
    });

    //
    //
    //
  });

  //
  //
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
        // act
        repository.getRondomNumberTrivia();

        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRondomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          // act
          final _result = await repository.getRondomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRondomNumberTrivia());
          expect(_result, equals(Right(tNumberTriviaModel)));
        },
      );

      test(
        'should cache the data localy when the call to remote data source is successfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRondomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          // act
          final _result = await repository.getRondomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRondomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(mockRemoteDataSource.getRondomNumberTrivia())
              .thenThrow(ServerException());

          // act
          final _result = await repository.getRondomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRondomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(_result, equals(Left(ServerFailures())));
        },
      );

      //
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final _result = await repository.getRondomNumberTrivia();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(_result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final _result = await repository.getRondomNumberTrivia();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(_result, equals(Left(CacheFailures())));
        },
      );
    });

    //
    //
    //
  });
}
