import '../../../users_list/data/models/user_model.dart';

class UserDetailResponseModel {
  final UserModel user;

  UserDetailResponseModel({required this.user});

  factory UserDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDetailResponseModel(
      user: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': user.toJson(),
    };
  }
}
