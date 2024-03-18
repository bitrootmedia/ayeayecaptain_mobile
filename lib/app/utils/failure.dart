class Failure {
  final String code;
  final String message;

  Failure(this.code, this.message);

  @override
  String toString() {
    return 'Failure {code: $code, message: $message}';
  }
}
