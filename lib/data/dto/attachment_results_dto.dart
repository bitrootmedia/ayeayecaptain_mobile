import 'package:ayeayecaptain_mobile/data/dto/attachment_dto.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment_results.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment_results_dto.g.dart';

@JsonSerializable()
class AttachmentResultsDto {
  final int count;
  final int total;
  @JsonKey(name: 'page_size')
  final int pageSize;
  final int current;
  final List<AttachmentDto> results;

  AttachmentResultsDto(
    this.count,
    this.total,
    this.pageSize,
    this.current,
    this.results,
  );

  AttachmentResults toDomain() => AttachmentResults(
        attachmentsTotal: count,
        pagesTotal: total,
        pageSize: pageSize,
        page: current,
        attachments: results.map((e) => e.toDomain(current)).toList(),
      );

  factory AttachmentResultsDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentResultsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentResultsDtoToJson(this);
}
