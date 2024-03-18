import 'package:flutter/foundation.dart';

@immutable
class User {
  final int id;
  final String name;
  final String email;
  final DateTime created;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.created,
  });
}
