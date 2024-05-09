import 'package:ayeayecaptain_mobile/data/dto/project_dto.dart';
import 'package:ayeayecaptain_mobile/data/dto/user_dto.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_list_item_dto.g.dart';

@JsonSerializable()
class TaskListItemDto {
  final String id;
  final String title;
  final String? status;
  @JsonKey(name: 'eta_date')
  final DateTime? etaDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final String? tag;
  final int progress;
  final ProjectDto? project;
  final int? position;
  final UserDto? responsible;
  final UserDto owner;
  @JsonKey(name: 'is_closed')
  final bool isClosed;
  @JsonKey(name: 'is_urgent')
  final bool isUrgent;

  TaskListItemDto(
    this.id,
    this.title,
    this.status,
    this.etaDate,
    this.createdAt,
    this.updatedAt,
    this.tag,
    this.progress,
    this.project,
    this.position,
    this.responsible,
    this.owner,
    this.isClosed,
    this.isUrgent,
  );

  TaskListItem toDomain(int page) => TaskListItem(
        id: id,
        title: title,
        status: status,
        etaDate: etaDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        tag: tag,
        progress: progress,
        project: project?.toDomain(),
        position: position,
        responsible: responsible?.toDomain(),
        owner: owner.toDomain(),
        isClosed: isClosed,
        isUrgent: isUrgent,
        page: page,
      );

  factory TaskListItemDto.fromJson(Map<String, dynamic> json) =>
      _$TaskListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListItemDtoToJson(this);
}
