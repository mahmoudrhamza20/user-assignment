import 'package:equatable/equatable.dart';
import 'package:user_management_app/features/users_list/domain/entities/user.dart';

abstract class UserDetailState extends Equatable {
  final bool isEditing;
  final String firstName;
  final String lastName;

  const UserDetailState({
    this.isEditing = false,
    this.firstName = '',
    this.lastName = '',
  });

  @override
  List<Object?> get props => [isEditing, firstName, lastName];
}

class UserDetailInitial extends UserDetailState {
  const UserDetailInitial({
    super.isEditing,
    super.firstName,
    super.lastName,
  });
}

class UserDetailLoading extends UserDetailState {
  const UserDetailLoading({
    super.isEditing,
    super.firstName,
    super.lastName,
  });
}

class UserDetailLoaded extends UserDetailState {
  final User user;

  const UserDetailLoaded(
    this.user, {
    super.isEditing,
    super.firstName,
    super.lastName,
  });

  @override
  List<Object?> get props => [user, isEditing, firstName, lastName];
}

class UserDetailError extends UserDetailState {
  final String message;

  const UserDetailError(
    this.message, {
    super.isEditing,
    super.firstName,
    super.lastName,
  });

  @override
  List<Object?> get props => [message, isEditing, firstName, lastName];
}

class UserDetailUpdating extends UserDetailState {
  final User user;

  const UserDetailUpdating(
    this.user, {
    super.isEditing,
    super.firstName,
    super.lastName,
  });

  @override
  List<Object?> get props => [user, isEditing, firstName, lastName];
}

class UserDetailUpdateSuccess extends UserDetailState {
  final User user;

  const UserDetailUpdateSuccess(
    this.user, {
    super.isEditing,
    super.firstName,
    super.lastName,
  });

  @override
  List<Object?> get props => [user, isEditing, firstName, lastName];
}

class UserDetailUpdateError extends UserDetailState {
  final User user;
  final String message;

  const UserDetailUpdateError(
    this.user,
    this.message, {
    super.isEditing,
    super.firstName,
    super.lastName,
  });

  @override
  List<Object?> get props => [user, message, isEditing, firstName, lastName];
}
