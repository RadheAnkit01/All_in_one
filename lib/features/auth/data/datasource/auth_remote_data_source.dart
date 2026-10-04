import 'package:all_in_one/core/network/dio_client.dart';
import 'package:all_in_one/core/network/request_options.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/data/models/login_response_model.dart';
import 'package:all_in_one/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required this._dioClient});

  final DioClient _dioClient;

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    debugPrint("AuthRemoteDataSource login Called");
    final response = await _dioClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
      options: RequestOptionsConfig.public(),
    );

    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> getCurrentUser() async {
    debugPrint("AuthRemoteDataSource getCurrentUser Called");
    final response = await _dioClient.get<Map<String, dynamic>>(
      '/users/me',
      options: RequestOptionsConfig.authenticated(),
    );

    return UserModel.fromJson(response.data!);
  }
}
