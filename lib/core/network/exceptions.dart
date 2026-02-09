import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.statusCode]);
}

class ServerException extends AppException {
  ServerException(super.message, [super.statusCode]);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, [super.statusCode]);
}

class ValidationException extends AppException {
  ValidationException(super.message, [super.statusCode]);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class NoInternetException extends AppException {
  NoInternetException() : super('No internet connection');
}

// Exception handler utility
class ExceptionHandler {
  static AppException handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.',
            error.response?.statusCode);

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);

      case DioExceptionType.cancel:
        return NetworkException(
            'Request cancelled', error.response?.statusCode);

      case DioExceptionType.connectionError:
        return NetworkException(
            'No internet connection', error.response?.statusCode);

      case DioExceptionType.badCertificate:
        return NetworkException(
            'Certificate error', error.response?.statusCode);

      case DioExceptionType.unknown:
        return NetworkException(
            'Something went wrong', error.response?.statusCode);
    }
  }

  static AppException _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode;
    final message = _extractErrorMessage(response);

    switch (statusCode) {
      case 400:
        return ValidationException(message ?? 'Bad request', statusCode);
      case 401:
        return UnauthorizedException(message ?? 'Unauthorized', statusCode);
      case 403:
        return UnauthorizedException(message ?? 'Forbidden', statusCode);
      case 404:
        return ServerException(message ?? 'Not found', statusCode);
      case 500:
      case 502:
      case 503:
        return ServerException(message ?? 'Server error', statusCode);
      default:
        return ServerException(message ?? 'Something went wrong', statusCode);
    }
  }

  static String? _extractErrorMessage(Response? response) {
    if (response?.data == null) return null;

    try {
      final data = response!.data;
      if (data is Map<String, dynamic>) {
        return data['error'] ?? data['message'] ?? data['detail'];
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
