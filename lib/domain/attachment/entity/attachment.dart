import 'package:ayeayecaptain_mobile/domain/project/entity/project.dart';
import 'package:ayeayecaptain_mobile/domain/user/entity/user.dart';
import 'package:flutter/foundation.dart';

@immutable
class Attachment {
  final String id;
  final String title;
  final DateTime createdAt;
  final String filePath;
  final String thumbnailPath;
  final User owner;
  final Project project;

  const Attachment({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.filePath,
    required this.thumbnailPath,
    required this.owner,
    required this.project,
  });
}
