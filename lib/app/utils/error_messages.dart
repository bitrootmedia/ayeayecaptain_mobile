import 'package:dio/dio.dart';

String getUnknownDioErrorMessage(DioException e) {
  return 'Response status message: ${e.response?.statusMessage}, code ${e.response?.statusCode};\nError message: ${e.message};\nError: ${e.error}';
}
