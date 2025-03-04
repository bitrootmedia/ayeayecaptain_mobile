import 'package:ayeayecaptain_mobile/app/utils/failure_or_result.dart';
import 'package:ayeayecaptain_mobile/data/dto/project_dto.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:ayeayecaptain_mobile/domain/project/interface/project_repository.dart' as domain;
import 'package:dio/dio.dart';

class ProjectRepository implements domain.ProjectRepository {
  final Dio _client;

  ProjectRepository(this._client);

  @override
  Future<FailureOrResult<List<Project>>> getProjects(Profile profile) async {
    final response = await _client.get(
      '${profile.backendUrl}/api/projects',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${profile.token}',
      }),
    );

    final projectsDto = (response.data['results'] as List).map((e) => ProjectDto.fromJson(e as Map<String, dynamic>));
    return FailureOrResult.success(projectsDto.map((e) => e.toDomain()).toList());
  }
}
