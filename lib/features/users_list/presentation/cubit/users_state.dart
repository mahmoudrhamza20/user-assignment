import 'package:equatable/equatable.dart';
import 'package:user_management_app/features/users_list/domain/entities/user.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const UsersLoaded({
    required this.users,
    required this.currentPage,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  UsersLoaded copyWith({
    List<User>? users,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [users, currentPage, hasReachedMax, isLoadingMore];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsersRefreshing extends UsersState {
  final List<User> users;

  const UsersRefreshing(this.users);

  @override
  List<Object?> get props => [users];
}
