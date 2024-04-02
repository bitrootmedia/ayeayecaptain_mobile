import 'package:ayeayecaptain_mobile/data/repository/profile_repository.dart';
import 'package:ayeayecaptain_mobile/domain/profile/interface/profile_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/data/repository/project_repository.dart';
import 'package:ayeayecaptain_mobile/domain/project/interface/project_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/data/repository/task_repository.dart';
import 'package:ayeayecaptain_mobile/domain/task/interface/task_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/data/repository/file_repository.dart';
import 'package:ayeayecaptain_mobile/domain/file/interface/file_repository.dart'
    as domain;
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_route_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/state/navigation_state.dart';
import 'package:ayeayecaptain_mobile/redux/profile/profile_middleware.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_reducer.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/project/project_middleware.dart';
import 'package:ayeayecaptain_mobile/redux/task/task_middleware.dart';
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
import 'package:dio_smart_retry/dio_smart_retry.dart';

Future<void> initialize() async {
  di.registerSingleton(await SharedPreferences.getInstance());
  di.registerSingleton(const FlutterSecureStorage());

  final dio = Dio();
  dio.interceptors.addAll([
    LoggingInterceptor(),
    RetryInterceptor(dio: dio),
  ]);
  di.registerSingleton(dio);

  di.registerSingleton<domain.ProfileRepository>(ProfileRepository(di(), di()));
  di.registerSingleton<domain.ProjectRepository>(ProjectRepository(di()));
  di.registerSingleton<domain.TaskRepository>(TaskRepository(di()));
  di.registerSingleton<domain.FileRepository>(FileRepository(di()));

  di.registerSingleton(
    Store<AppState>(
      AppReducer().call,
      initialState: await _initAppState(),
      middleware: [
        ProfileMiddleware(di()).call,
        ProjectMiddleware(di()).call,
        TaskMiddleware(di()).call,
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

Future<AppState> _initAppState() async {
  final hasProfile = await di<domain.ProfileRepository>().hasProfile();

  return AppState.initial().copyWith(
    navigationState: NavigationState.initial().copyWith(
      currentRoute: hasProfile
          ? const NavigationRouteState(
              isHomePageOpened: true,
            )
          : const NavigationRouteState(
              isCreateProfilePageOpened: true,
            ),
    ),
  );
}
