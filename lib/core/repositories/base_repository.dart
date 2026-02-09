import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../network/exceptions.dart';

abstract class BaseRepository {
  Future<Either<AppException, T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on AppException catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(ExceptionHandler.handleDioException(e));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}
