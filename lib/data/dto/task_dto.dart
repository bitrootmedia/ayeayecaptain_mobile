import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  final String id;
  final String title;

  TaskDto(
    this.id,
    this.title,
  );

  Task toDomain() => Task(
        id: id,
        title: title,
      );

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}
