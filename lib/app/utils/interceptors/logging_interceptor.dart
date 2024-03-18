import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  final JsonEncoder _encoder = const JsonEncoder.withIndent('  ');

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '''${response.requestOptions.method} ${response.requestOptions.uri}
Response data (${response.requestOptions.responseType.name}): ${_encoder.convert(response.data)}''',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '''${err.requestOptions.method} ${err.requestOptions.uri}
Error: ${err.message}
Stack trace: ${err.stackTrace}''',
    );

    super.onError(err, handler);
  }
}
