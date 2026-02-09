import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/user_repository.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository _userRepository;

  UsersCubit(this._userRepository) : super(UsersInitial());

  Future<void> fetchUsers({bool isRefresh = false}) async {
    try {
      if (isRefresh && state is UsersLoaded) {
        emit(UsersRefreshing((state as UsersLoaded).users));
      } else if (!isRefresh) {
        emit(UsersLoading());
      }

      final result = await _userRepository.getUsers(1);

      if (isClosed) return;

      result.fold(
        (failure) => emit(UsersError(failure.message)),
        (users) => emit(UsersLoaded(
          users: users,
          currentPage: 1,
          hasReachedMax: users.isEmpty,
        )),
      );
    } catch (e) {
      if (!isClosed) emit(const UsersError('Failed to fetch users'));
    }
  }

  Future<void> loadMoreUsers() async {
    final currentState = state;
    if (currentState is! UsersLoaded ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      final result = await _userRepository.getUsers(nextPage);

      if (isClosed) return;

      result.fold(
        (failure) => emit(currentState.copyWith(isLoadingMore: false)),
        (newUsers) {
          if (newUsers.isEmpty) {
            emit(currentState.copyWith(
              hasReachedMax: true,
              isLoadingMore: false,
            ));
          } else {
            emit(UsersLoaded(
              users: [...currentState.users, ...newUsers],
              currentPage: nextPage,
              hasReachedMax:
                  newUsers.length < 6, // ReqRes returns 6 users per page
              isLoadingMore: false,
            ));
          }
        },
      );
    } catch (_) {
      if (!isClosed) emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refreshUsers() async {
    await fetchUsers(isRefresh: true);
  }
}
