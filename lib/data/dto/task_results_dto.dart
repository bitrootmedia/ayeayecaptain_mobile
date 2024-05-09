import 'package:ayeayecaptain_mobile/data/dto/task_list_item_dto.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task_results.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_results_dto.g.dart';

@JsonSerializable()
class TaskResultsDto {
  final int count;
  final int total;
  @JsonKey(name: 'page_size')
  final int pageSize;
  final int current;
  final List<TaskListItemDto> results;

  TaskResultsDto(
    this.count,
    this.total,
    this.pageSize,
    this.current,
    this.results,
  );

  TaskResults toDomain() => TaskResults(
        tasksTotal: count,
        pagesTotal: total,
        pageSize: pageSize,
        page: current,
        tasks: results.map((e) => e.toDomain(current)).toList(),
      );

  factory TaskResultsDto.fromJson(Map<String, dynamic> json) =>
      _$TaskResultsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResultsDtoToJson(this);
}
