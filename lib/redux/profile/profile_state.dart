import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

class ProfileState {
  final List<Profile>? profiles;

  ProfileState({
    required this.profiles,
  });

  ProfileState.initial() : profiles = null;

  Profile? get selected => profiles?.singleWhere((e) => e.isSelected);

  ProfileState copyWith({
    List<Profile>? profiles,
  }) =>
      ProfileState(
        profiles: profiles ?? this.profiles,
      );
}
