import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class AttachmentSection extends StatelessWidget {
  final String taskId;

  const AttachmentSection({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store, taskId),
      onInitialBuild: (viewModel) => viewModel.getAttachments(),
      builder: (context, viewModel) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attachments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              viewModel.isLoaded
                  ? viewModel.hasAttachments
                      ? Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    viewModel.currentPageAttachments.length,
                                itemBuilder: (context, index) =>
                                    getAttachmentTale(
                                  viewModel.currentPageAttachments[index],
                                ),
                                separatorBuilder: (context, index) => Divider(
                                  thickness: 0.5,
                                  height: 0.5,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            getPagination(
                              current: viewModel.task.attachmentsCurrentPage!,
                              total: viewModel.task.attachmentsPagesTotal!,
                              goToNext: viewModel.getGoToNext(),
                              goToPrevious: viewModel.getGoToPrevious(),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget getAttachmentTale(Attachment attachment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(attachment.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      attachment.owner.username,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (attachment.project != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.folder,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        attachment.project!.title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          attachment.thumbnailPath == null
              ? const SizedBox(
                  width: 70,
                  height: 70,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.grey,
                    ),
                  ),
                )
              : getImage(attachment.thumbnailPath!),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  Widget getImage(String src) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          src,
          cacheHeight: 70,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getPagination({
    required int current,
    required int total,
    required VoidCallback? goToNext,
    required VoidCallback? goToPrevious,
  }) {
    return total > 1
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              goToPrevious == null
                  ? const SizedBox(width: 48)
                  : IconButton(
                      onPressed: goToPrevious,
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$current / $total',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              goToNext == null
                  ? const SizedBox(width: 48)
                  : IconButton(
                      onPressed: goToNext,
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final String taskId;
  final List<Task>? tasks;

  _ViewModel(
    this._store,
    this.taskId,
  ) : tasks = _store.state.taskState.tasks;

  Task get task => tasks!.singleWhere((e) => e.id == taskId);

  void getAttachments([int? page]) {
    page ??= task.attachmentsCurrentPage ?? 1;
    if (!isLoaded || !task.attachments!.any((e) => e.page == page)) {
      _store.dispatch(GetTaskAttachmentsAction(
        taskId: taskId,
        page: page,
        pageSize: attachmentsPageSize,
      ));
    } else {
      _store.dispatch(UpdateTaskAttachmentsPageAction(
        taskId: taskId,
        page: page,
      ));
    }
  }

  VoidCallback? getGoToNext() {
    return task.attachmentsCurrentPage! < task.attachmentsPagesTotal!
        ? () => getAttachments(task.attachmentsCurrentPage! + 1)
        : null;
  }

  VoidCallback? getGoToPrevious() {
    return task.attachmentsCurrentPage! > 1
        ? () => getAttachments(task.attachmentsCurrentPage! - 1)
        : null;
  }

  List<Attachment> get currentPageAttachments => task.attachments!
      .where((e) => e.page == task.attachmentsCurrentPage)
      .toList();

  bool get isLoaded => task.attachments != null;

  bool get hasAttachments =>
      task.attachments != null && task.attachments!.isNotEmpty;

  @override
  List<Object?> get props => [tasks];
}
