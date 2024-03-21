import 'package:ayeayecaptain_mobile/app/theme/app_theme.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/router/app/app_route_information_parser.dart';
import 'package:ayeayecaptain_mobile/app/router/app/app_router_delegate.dart';

import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  final Store<AppState> store;

  const App({
    super.key,
    required this.store,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppRouteInformationParser _parser;
  late AppRouterDelegate _delegate;

  @override
  void initState() {
    _parser = AppRouteInformationParser();
    _delegate = AppRouterDelegate(widget.store);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: MaterialApp.router(
        routeInformationParser: _parser,
        routerDelegate: _delegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: _resolveLocale,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: snackbarKey,
      ),
    );
  }

  Locale? _resolveLocale(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale != null &&
        !supportedLocales
            .map((e) => e.languageCode)
            .contains(locale.languageCode)) {
      return const Locale('en');
    }
    return null;
  }
}
