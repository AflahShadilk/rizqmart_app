import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rizqmart/core/error/exceptions.dart';
import 'package:rizqmart/core/error/failures.dart';

/// Centralized error handling utility to wrap API calls and stream operations safely.
class ErrorHandler {
  static Future<Either<Failure, T>> executeApiCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on SocketException catch (_) {
      return const Left(NetworkFailure());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'A Firebase error occurred'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  static Stream<Either<Failure, T>> executeApiStream<T>(Stream<T> Function() call) async* {
    try {
      yield* call().map((data) => Right<Failure, T>(data)).handleError((error) {
        if (error is SocketException) {
          return  Left<Failure, T>(NetworkFailure());
        } else if (error is FirebaseException) {
          return Left<Failure, T>(ServerFailure(error.message ?? 'A Firebase error occurred'));
        } else if (error is ServerException) {
          return Left<Failure, T>(ServerFailure(error.message));
        } else if (error is AuthException) {
          return Left<Failure, T>(AuthFailure(error.message));
        } else if (error is NetworkException) {
          return Left<Failure, T>(NetworkFailure(error.message));
        } else if (error is CacheException) {
          return Left<Failure, T>(CacheFailure(error.message));
        } else {
          return Left<Failure, T>(UnknownFailure(error.toString()));
        }
      });
    } catch (e) {
      yield Left(UnknownFailure(e.toString()));
    }
  }
}
