import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';

class GetProfilesAction {}

class UpdateProfilesAction {
  final List<Profile> profiles;

  UpdateProfilesAction(this.profiles);
}

class SaveProfilesAction {
  final List<Profile> profiles;

  SaveProfilesAction(this.profiles);
}

class LoginAction {
  final Profile profile;

  LoginAction(this.profile);
}
