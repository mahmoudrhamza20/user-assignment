import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/network/exceptions.dart';
import 'package:user_management_app/features/users_list/domain/entities/user.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../user_detail/data/models/user_detail_response_model.dart';
import '../models/users_response_model.dart';

class UserRepository extends BaseRepository {
  final DioClient _dioClient;

  UserRepository(this._dioClient);

  Future<Either<AppException, List<User>>> getUsers(int page) async {
    return safeCall(() async {
      final response = await _dioClient.get(
        ApiConstants.users,
        queryParameters: {'page': page},
      );

      final usersResponse = UsersResponseModel.fromJson(response.data);
      return usersResponse.users.map((model) => model.toEntity()).toList();
    });
  }

  Future<Either<AppException, User>> getUserDetail(int userId) async {
    return safeCall(() async {
      final response = await _dioClient.get('${ApiConstants.users}/$userId');

      final userDetailResponse =
          UserDetailResponseModel.fromJson(response.data);
      return userDetailResponse.user.toEntity();
    });
  }

  Future<Either<AppException, User>> updateUser(
      int userId, String firstName, String lastName) async {
    return safeCall(() async {
      final response = await _dioClient.put(
        '${ApiConstants.users}/$userId',
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      final updatedData = response.data as Map<String, dynamic>;

      return User(
        id: userId,
        email: '',
        firstName: updatedData['first_name'] ?? firstName,
        lastName: updatedData['last_name'] ?? lastName,
        avatar: '',
      );
    });
  }
}
