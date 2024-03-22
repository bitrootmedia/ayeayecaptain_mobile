import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';

class GetProjectsAction {
  final Profile profile;

  GetProjectsAction(this.profile);
}

class UpdateProjectsAction {
  final List<Project> projects;

  UpdateProjectsAction(this.projects);
}

class ResetProjectsAction {}
