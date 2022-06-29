import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_event.dart';

import 'number_trivia_state.dart';

const String kServerFailureMessage = 'Server Failure';
const String kCacheFailureMessage = 'Cache Failure';
const String kInvalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
  }

  FutureOr<void> _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
        (failure) => emit(Error(message: kInvalidInputFailureMessage)),
        (integer) => throw UnimplementedError());
  }
}
