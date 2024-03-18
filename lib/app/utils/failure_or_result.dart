import 'package:ayeayecaptain_mobile/app/utils/failure.dart';

class FailureOrResult<T> {
  final Failure? failure;
  final T? result;

  FailureOrResult.failure({String? code, String? message})
      : failure = Failure(code ?? '', message ?? ''),
        result = null;

  FailureOrResult.success(this.result) : failure = null;

  bool get hasFailed => failure != null;

  bool get wasSuccessful => failure == null;
}
