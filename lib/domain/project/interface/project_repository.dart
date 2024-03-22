import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';

abstract class ProjectRepository {
  Future<FailureOrResult<List<Project>>> getProjects(Profile profile);
}
