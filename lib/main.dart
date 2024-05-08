import 'dart:async';
import 'dart:developer';

import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ayeayecaptain_mobile/app/app.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/initializer.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
      await initialize();
      runApp(App(store: di()));
    },
    (error, stackTrace) {
      log('App error', error: error, stackTrace: stackTrace);
      di<Store<AppState>>().dispatch(
        OpenAlertDialogAction(
          DialogConfig(
            title: 'App error',
            content: '$error\n$stackTrace',
          ),
        ),
      );
    },
  );
}
