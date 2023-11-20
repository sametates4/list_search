import 'dart:io';

import 'package:dio/dio.dart';

import '../model/user_model.dart';

class NetworkService {
  final dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  Future<List<UserModel>?> fetchUser() async {
    final response = await dio.get('/users');

    if (response.statusCode == HttpStatus.ok) {
      final responses = response.data;
      if (responses is List) {
        return responses.map((e) => UserModel.fromJson(e)).toList();
      }
    }
    return null;
  }
}
