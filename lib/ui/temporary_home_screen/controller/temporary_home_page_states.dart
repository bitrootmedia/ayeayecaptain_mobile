class TemporaryHomePageStates {}

class TemporaryHomePageInitialState extends TemporaryHomePageStates {}

class TemporaryHomePageRefreshState extends TemporaryHomePageStates {}

class FetchHomePageState extends TemporaryHomePageStates {
  FetchHomePageState({required this.status, this.response = const {}});

  final StateStatus status;
  final Map<String, dynamic> response;
}

class HomeClickMeActionState extends TemporaryHomePageStates {
  HomeClickMeActionState({required this.status, this.message = ""});

  final StateStatus status;
  final String message;
}

class HomeActionButtonState extends TemporaryHomePageStates {
  HomeActionButtonState({required this.status, this.message = ""});

  final StateStatus status;
  final String message;
}

enum StateStatus { loading, success, error }
