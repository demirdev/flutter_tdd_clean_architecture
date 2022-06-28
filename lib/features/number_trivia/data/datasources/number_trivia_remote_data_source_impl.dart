import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/number_tirivia_model.dart';
import 'package:http/http.dart' as http;

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final result = await client.get(
        Uri.parse(
          url,
        ),
        headers: {
          'Content-Type': 'application/json',
        });

    if (result.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(result.body));
    } else {
      throw ServerException();
    }
  }
}
