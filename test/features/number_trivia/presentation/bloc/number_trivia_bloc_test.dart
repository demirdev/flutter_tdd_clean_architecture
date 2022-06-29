import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter,
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should emit [Error] when the input is invalid',
        build: () => bloc,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        act: (bloc) {
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
        },
        expect: () => [Error(message: kInvalidInputFailureMessage)]);

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange

        // assert later

        // expectLater(bloc.stream, emitsInOrder(expected));

        // act
      },
    );
  });
}
