import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/features/users_list/domain/entities/user.dart';

import '../../../../features/users_list/data/repositories/user_repository.dart';
import 'user_detail_state.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  final UserRepository _userRepository;

  UserDetailCubit(
    this._userRepository,
  ) : super(const UserDetailInitial());

  void toggleEdit() {
    final newState = !state.isEditing;
    if (state is UserDetailInitial) {
      emit(UserDetailInitial(
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailLoading) {
      emit(UserDetailLoading(
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailLoaded) {
      emit(UserDetailLoaded(
        (state as UserDetailLoaded).user,
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailUpdating) {
      emit(UserDetailUpdating(
        (state as UserDetailUpdating).user,
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailUpdateSuccess) {
      emit(UserDetailUpdateSuccess(
        (state as UserDetailUpdateSuccess).user,
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailUpdateError) {
      final errorState = state as UserDetailUpdateError;
      emit(UserDetailUpdateError(
        errorState.user,
        errorState.message,
        isEditing: newState,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
    }
  }

  void cancelUpdate() {
    toggleEdit();
  }

  void updateFirstName(String name) {
    if (state is UserDetailLoaded) {
      emit(UserDetailLoaded(
        (state as UserDetailLoaded).user,
        isEditing: state.isEditing,
        firstName: name,
        lastName: state.lastName,
      ));
    } else if (state is UserDetailUpdateError) {
      final errorState = state as UserDetailUpdateError;
      emit(UserDetailUpdateError(
        errorState.user,
        errorState.message,
        isEditing: state.isEditing,
        firstName: name,
        lastName: state.lastName,
      ));
    }
  }

  void updateLastName(String name) {
    if (state is UserDetailLoaded) {
      emit(UserDetailLoaded(
        (state as UserDetailLoaded).user,
        isEditing: state.isEditing,
        firstName: state.firstName,
        lastName: name,
      ));
    } else if (state is UserDetailUpdateError) {
      final errorState = state as UserDetailUpdateError;
      emit(UserDetailUpdateError(
        errorState.user,
        errorState.message,
        isEditing: state.isEditing,
        firstName: state.firstName,
        lastName: name,
      ));
    }
  }

  Future<void> fetchUserDetail(int userId) async {
    try {
      emit(UserDetailLoading(
        isEditing: state.isEditing,
        firstName: state.firstName,
        lastName: state.lastName,
      ));
      final result = await _userRepository.getUserDetail(userId);
      if (isClosed) return;

      result.fold(
        (failure) => emit(UserDetailError(
          failure.message,
          isEditing: state.isEditing,
          firstName: state.firstName,
          lastName: state.lastName,
        )),
        (user) => emit(UserDetailLoaded(
          user,
          isEditing: state.isEditing,
          firstName: user.firstName,
          lastName: user.lastName,
        )),
      );
    } catch (e) {
      if (!isClosed) {
        emit(UserDetailError(
          'Failed to fetch user details',
          isEditing: state.isEditing,
          firstName: state.firstName,
          lastName: state.lastName,
        ));
      }
    }
  }

  Future<void> updateUser(int userId) async {
    final currentState = state;
    User? currentUser;
    if (currentState is UserDetailLoaded) {
      currentUser = currentState.user;
    } else if (currentState is UserDetailUpdating) {
      currentUser = currentState.user;
    } else if (currentState is UserDetailUpdateSuccess) {
      currentUser = currentState.user;
    } else if (currentState is UserDetailUpdateError) {
      currentUser = currentState.user;
    }

    if (currentUser == null) return;

    try {
      emit(UserDetailUpdating(
        currentUser,
        isEditing: state.isEditing,
        firstName: state.firstName,
        lastName: state.lastName,
      ));

      if (currentUser.firstName == state.firstName &&
          currentUser.lastName == state.lastName) {
        emit(UserDetailUpdateError(
          currentUser,
          'No changes to save',
          isEditing: state.isEditing,
          firstName: state.firstName,
          lastName: state.lastName,
        ));

        await Future.delayed(const Duration(seconds: 2));
        if (isClosed) return;
        emit(UserDetailLoaded(
          currentUser,
          isEditing: state.isEditing,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
        ));
        return;
      }

      final result = await _userRepository.updateUser(
        userId,
        state.firstName,
        state.lastName,
      );

      if (isClosed) return;

      result.fold(
        (failure) async {
          emit(UserDetailUpdateError(
            currentUser!,
            failure.message,
            isEditing: state.isEditing,
            firstName: state.firstName,
            lastName: state.lastName,
          ));

          await Future.delayed(const Duration(seconds: 2));
          if (!isClosed) {
            emit(UserDetailLoaded(
              currentUser,
              isEditing: state.isEditing,
              firstName: currentUser.firstName,
              lastName: currentUser.lastName,
            ));
          }
        },
        (updatedUser) async {
          final completeUser = currentUser!.copyWith(
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
          );

          emit(UserDetailUpdateSuccess(
            completeUser,
            isEditing: false,
            firstName: completeUser.firstName,
            lastName: completeUser.lastName,
          ));

          await Future.delayed(const Duration(milliseconds: 500));
          if (!isClosed) {
            emit(UserDetailLoaded(
              completeUser,
              isEditing: false,
              firstName: completeUser.firstName,
              lastName: completeUser.lastName,
            ));
          }
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(UserDetailUpdateError(
        currentUser,
        'Failed to update user',
        isEditing: state.isEditing,
        firstName: state.firstName,
        lastName: state.lastName,
      ));

      await Future.delayed(const Duration(seconds: 2));
      if (!isClosed) {
        emit(UserDetailLoaded(
          currentUser,
          isEditing: state.isEditing,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
        ));
      }
    }
  }
}
