import 'package:all_in_one/core/network/dio_client.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/data/models/login_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dioClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
