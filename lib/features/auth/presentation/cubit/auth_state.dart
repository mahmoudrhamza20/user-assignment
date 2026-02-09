import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final bool obscurePassword;
  final String email;
  final String password;

  const AuthState({
    this.obscurePassword = true,
    this.email = '',
    this.password = '',
  });

  @override
  List<Object?> get props => [obscurePassword, email, password];
}

class AuthInitial extends AuthState {
  const AuthInitial({
    super.obscurePassword,
    super.email,
    super.password,
  });
}

class AuthLoading extends AuthState {
  const AuthLoading({
    super.obscurePassword,
    super.email,
    super.password,
  });
}

class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated(
    this.token, {
    super.obscurePassword,
    super.email,
    super.password,
  });

  @override
  List<Object?> get props => [token, obscurePassword, email, password];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({
    super.obscurePassword,
    super.email,
    super.password,
  });
}

class AuthError extends AuthState {
  final String message;

  const AuthError(
    this.message, {
    super.obscurePassword,
    super.email,
    super.password,
  });

  @override
  List<Object?> get props => [message, obscurePassword, email, password];
}
