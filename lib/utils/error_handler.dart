import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'strings.dart';

enum ErrorType {
  network,
  timeout,
  server,
  validation,
  sessionExpired,
  forceUpdate,
  unknown,
}

class AppError implements Exception {
  final String message;
  final ErrorType type;
  final int? statusCode;

  AppError({
    required this.message,
    required this.type,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ErrorHandler {
  // TODO:: HANDLE API ERRORS CENTRALIZED
  static AppError handle(dynamic error) {
    if (error is SocketException) {
      return AppError(
        message: AppStrings.errorNetwork,
        type: ErrorType.network,
      );
    } else if (error is TimeoutException) {
      return AppError(
        message: AppStrings.errorTimeout,
        type: ErrorType.timeout,
      );
    } else if (error is AppError) {
      return error;
    } else {
      return AppError(
        message: AppStrings.errorUnknown,
        type: ErrorType.unknown,
      );
    }
  }

  // TODO:: HANDLE HTTP RESPONSES
  static void handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return;
      case 400:
        throw AppError(
          message: AppStrings.errorValidation,
          type: ErrorType.validation,
          statusCode: 400,
        );
      case 401:
      case 403:
        throw AppError(
          message: AppStrings.errorSessionExpired,
          type: ErrorType.sessionExpired,
          statusCode: response.statusCode,
        );
      case 426:
        throw AppError(
          message: AppStrings.errorForceUpdate,
          type: ErrorType.forceUpdate,
          statusCode: 426,
        );
      case 500:
      case 502:
      case 503:
        throw AppError(
          message: AppStrings.errorServer,
          type: ErrorType.server,
          statusCode: response.statusCode,
        );
      default:
        throw AppError(
          message: AppStrings.errorUnknown,
          type: ErrorType.unknown,
          statusCode: response.statusCode,
        );
    }
  }
}
