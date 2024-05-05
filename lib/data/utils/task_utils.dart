import 'package:ayeayecaptain_mobile/data/dto/blocks/block_dto.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';

bool tasksIdentical(Task a, Task b) {
  return a.title +
          a.blocks
              .map((e) => BlockDto.fromDomain(e))
              .map((e) => e.toJson())
              .toList()
              .toString() ==
      b.title +
          b.blocks
              .map((e) => BlockDto.fromDomain(e))
              .map((e) => e.toJson())
              .toList()
              .toString();
}
