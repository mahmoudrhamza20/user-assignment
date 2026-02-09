import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  AuthCubit(
    this._authRepository,
    this._storageService,
  ) : super(const AuthInitial()) {
    emailController.addListener(() {
      updateEmail(emailController.text);
    });
    passwordController.addListener(() {
      updatePassword(passwordController.text);
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void checkAuthStatus() {
    if (_storageService.isLoggedIn()) {
      final token = _storageService.getAuthToken();
      emit(AuthAuthenticated(
        token!,
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: state.password,
      ));
    } else {
      emit(AuthUnauthenticated(
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: state.password,
      ));
    }
  }

  void updateEmail(String email) {
    if (state is AuthInitial) {
      emit(AuthInitial(
        obscurePassword: state.obscurePassword,
        email: email,
        password: state.password,
      ));
    } else if (state is AuthUnauthenticated) {
      emit(AuthUnauthenticated(
        obscurePassword: state.obscurePassword,
        email: email,
        password: state.password,
      ));
    } else if (state is AuthError) {
      emit(AuthError(
        (state as AuthError).message,
        obscurePassword: state.obscurePassword,
        email: email,
        password: state.password,
      ));
    }
  }

  void updatePassword(String password) {
    if (state is AuthInitial) {
      emit(AuthInitial(
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: password,
      ));
    } else if (state is AuthUnauthenticated) {
      emit(AuthUnauthenticated(
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: password,
      ));
    } else if (state is AuthError) {
      emit(AuthError(
        (state as AuthError).message,
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: password,
      ));
    }
  }

  void togglePasswordVisibility() {
    final newState = !state.obscurePassword;
    if (state is AuthInitial) {
      emit(AuthInitial(
        obscurePassword: newState,
        email: state.email,
        password: state.password,
      ));
    } else if (state is AuthLoading) {
      emit(AuthLoading(
        obscurePassword: newState,
        email: state.email,
        password: state.password,
      ));
    } else if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(
        (state as AuthAuthenticated).token,
        obscurePassword: newState,
        email: state.email,
        password: state.password,
      ));
    } else if (state is AuthUnauthenticated) {
      emit(AuthUnauthenticated(
        obscurePassword: newState,
        email: state.email,
        password: state.password,
      ));
    } else if (state is AuthError) {
      emit(AuthError(
        (state as AuthError).message,
        obscurePassword: newState,
        email: state.email,
        password: state.password,
      ));
    }
  }

  Future<void> login() async {
    try {
      emit(AuthLoading(
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: state.password,
      ));
      final result = await _authRepository.login(state.email, state.password);

      if (isClosed) return;

      result.fold(
        (failure) => emit(AuthError(
          failure.message,
          obscurePassword: state.obscurePassword,
          email: state.email,
          password: state.password,
        )),
        (token) {
          emailController.clear();
          passwordController.clear();
          emit(AuthAuthenticated(
            token,
            obscurePassword: state.obscurePassword,
            email: state.email,
            password: state.password,
          ));
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(
          'An unexpected error occurred',
          obscurePassword: state.obscurePassword,
          email: state.email,
          password: state.password,
        ));
      }
    }
  }

  Future<void> logout() async {
    final result = await _authRepository.logout();
    if (isClosed) return;

    result.fold(
      (failure) => emit(AuthError(
        failure.message,
        obscurePassword: state.obscurePassword,
        email: state.email,
        password: state.password,
      )),
      (_) {
        emailController.clear();
        passwordController.clear();
        emit(AuthUnauthenticated(
          obscurePassword: state.obscurePassword,
          email: '',
          password: '',
        ));
      },
    );
  }
}
