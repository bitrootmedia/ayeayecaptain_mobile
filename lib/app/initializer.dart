import 'package:ayeayecaptain_mobile/data/repository/profile_repository.dart';
import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/redux/profile/profile_middleware.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_reducer.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/utils/interceptors/logging_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initialize() async {
  di.registerSingleton(await SharedPreferences.getInstance());
  di.registerSingleton(const FlutterSecureStorage());

  di.registerSingleton(
    Dio(
      BaseOptions(
        baseUrl: 'https://stage-api.ayeayecaptain.io/',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.add(LoggingInterceptor()),
  );

  di.registerSingleton<domain.ProfileRepository>(ProfileRepository(di(), di()));

  di.registerSingleton(
    Store<AppState>(
      AppReducer().call,
      initialState: _initAppState(),
      middleware: [
        ProfileMiddleware(di()).call,
        LoggingMiddleware(
          logger: Logger('Redux Logger')
            ..onRecord
                .where((record) => record.loggerName == 'Redux Logger')
                .listen((record) => debugPrint(record.message)),
          formatter: (state, action, timestamp) => 'Action: $action',
        ).call,
      ],
    ),
  );
}

AppState _initAppState() {
  return AppState.initial();
}
