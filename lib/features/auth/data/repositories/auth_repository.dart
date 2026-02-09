import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/storage/storage_service.dart';
import '../models/login_response_model.dart';

class AuthRepository extends BaseRepository {
  final DioClient _dioClient;
  final StorageService _storageService;

  AuthRepository(this._dioClient, this._storageService);

  Future<Either<AppException, String>> login(
      String email, String password) async {
    return safeCall(() async {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);
      await _storageService.saveAuthToken(loginResponse.token);

      return loginResponse.token;
    });
  }

  Future<Either<AppException, void>> logout() async {
    return safeCall(() async {
      await _storageService.removeAuthToken();
    });
  }

  bool isLoggedIn() => _storageService.isLoggedIn();
}
