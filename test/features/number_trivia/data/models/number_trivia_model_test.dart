import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_tirivia_model.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert

      expect(testNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is an double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            jsonDecode(fixture('trivia_double.json'));

        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        // assert
        expect(result, testNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = testNumberTriviaModel.toJson();
        // assert
        var expectedMap = {"text": "Test text", "number": 1};

        expect(result, expectedMap);
      },
    );
  });
}
