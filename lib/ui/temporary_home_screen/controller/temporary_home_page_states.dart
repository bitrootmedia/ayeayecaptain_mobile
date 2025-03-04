class TemporaryHomePageStates {}

class TemporaryHomePageInitialState extends TemporaryHomePageStates {}

class TemporaryHomePageRefreshState extends TemporaryHomePageStates {}

class FetchHomePageState extends TemporaryHomePageStates {
  FetchHomePageState({
    required this.status,
    this.response = const {},
  });

  final StateStatus status;
  final Map<String, dynamic> response;
}

class HomeClickMeActionState extends TemporaryHomePageStates {
  HomeClickMeActionState({
    required this.status,
  });

  final StateStatus status;
}

enum StateStatus { loading, success, error }
