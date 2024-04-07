import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });
}
