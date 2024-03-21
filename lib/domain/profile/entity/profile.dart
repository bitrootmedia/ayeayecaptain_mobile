import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Profile extends Equatable {
  final String backendUrl;
  final String name;
  final String password;
  final String? token;
  final bool isSelected;

  const Profile({
    required this.backendUrl,
    required this.name,
    required this.password,
    this.token,
    required this.isSelected,
  });

  Profile copyWith({
    String? token,
    bool? isSelected,
  }) =>
      Profile(
        backendUrl: backendUrl,
        name: name,
        password: password,
        token: token ?? this.token,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  List<Object?> get props => [
        backendUrl,
        name,
        password,
        token,
        isSelected,
      ];
}
