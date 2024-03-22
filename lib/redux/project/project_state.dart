import 'package:ayeayecaptain_mobile/app/utils/nullable.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';

class ProjectState {
  final List<Project>? projects;

  ProjectState({
    required this.projects,
  });

  ProjectState.initial() : projects = null;

  ProjectState copyWith({
    Nullable<List<Project>>? projects,
  }) =>
      ProjectState(
        projects: projects == null ? this.projects : projects.value,
      );
}
