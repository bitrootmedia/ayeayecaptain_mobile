import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/attachment/entity/attachment.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/attachment/widget/attachment_order_dropdown.dart';
import 'package:ayeayecaptain_mobile/ui/components/pagination.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:file_picker/file_picker.dart';

class AttachmentSection extends StatefulWidget {
  final String taskId;

  const AttachmentSection({
    super.key,
    required this.taskId,
  });

  @override
  State<AttachmentSection> createState() => _AttachmentSectionState();
}

class _AttachmentSectionState extends State<AttachmentSection> {
  final store = di<Store<AppState>>();
  bool _isDownloading = false;

  void _deleteAttachment(String id, Task task) {
    store.dispatch(
      OpenAlertDialogAction(
        DialogConfig(
          content: 'Are you sure you want to delete this attachment?',
          actions: [
            DialogAction(
              label: 'Cancel',
            ),
            DialogAction(
              label: 'Delete',
              action: DeleteTaskAttachmentAction(id, task),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadAttachment(Attachment attachment) async {
    if (_isDownloading) return;
    _isDownloading = true;
    final fileName =
        '${attachment.title}.${attachment.filePath.split('.').last}';
    final response = await Dio().get(
      attachment.filePath,
      options: Options(responseType: ResponseType.bytes),
    );
    FilePicker.platform.saveFile(
      fileName: fileName,
      bytes: response.data,
    );
    _isDownloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel(store, widget.taskId),
      onInitialBuild: (viewModel) => viewModel.resetAttachments(),
      ignoreChange: (state) {
        return !state.taskState.tasks!.any((e) => e.id == widget.taskId);
      },
      builder: (context, viewModel) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: viewModel.isLoaded
              ? viewModel.hasAttachments
                  ? Column(
                      children: [
                        AttachmentOrderDropdown(task: viewModel.task),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: viewModel.currentPageAttachments.length,
                            itemBuilder: (context, index) => getAttachmentTale(
                              viewModel.currentPageAttachments[index],
                              viewModel.task,
                            ),
                            separatorBuilder: (context, index) => Divider(
                              thickness: 0.5,
                              height: 0.5,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        Pagination(
                          current: viewModel.task.attachmentsCurrentPage!,
                          total: viewModel.task.attachmentsPagesTotal!,
                          isDataLoading: viewModel.isAttachmentsLoading,
                          onPrevPressed: viewModel.onPrevPressed,
                          onNextPressed: viewModel.onNextPressed,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  Widget getAttachmentTale(
    Attachment attachment,
    Task task,
  ) {
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
              : getImage(
                  attachment.filePath,
                  attachment.thumbnailPath!,
                ),
          IconButton(
            onPressed: () => _downloadAttachment(attachment),
            icon: const Icon(
              Icons.download_rounded,
            ),
          ),
          IconButton(
            onPressed: () => _deleteAttachment(attachment.id, task),
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  Widget getImage(String filePath, String thumbnailPath) {
    return GestureDetector(
      onTap: () =>
          di<Store<AppState>>().dispatch(OpenViewImagePageAction(filePath)),
      child: SizedBox(
        width: 70,
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            thumbnailPath,
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
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final String taskId;
  final Task task;
  final bool isAttachmentsLoading;

  _ViewModel(
    this._store,
    this.taskId,
  )   : task = _store.state.taskState.task!,
        isAttachmentsLoading = _store.state.taskState.isAttachmentsLoading;

  void resetAttachments() {
    _store.dispatch(GetTaskAttachmentsAction(
      taskId: taskId,
      page: 1,
      pageSize: attachmentsPageSize,
      orderBy: task.attachmentsOrderBy,
      shouldReset: true,
    ));
  }

  void getAttachments([int? page]) {
    page ??= task.attachmentsCurrentPage ?? 1;
    if (!isLoaded || !task.attachments!.any((e) => e.page == page)) {
      _store.dispatch(GetTaskAttachmentsAction(
        taskId: taskId,
        page: page,
        pageSize: attachmentsPageSize,
        orderBy: task.attachmentsOrderBy,
      ));
    } else {
      _store.dispatch(UpdateTaskAttachmentsPageAction(
        taskId: taskId,
        page: page,
      ));
    }
  }

  void onPrevPressed() {
    getAttachments(task.attachmentsCurrentPage! - 1);
  }

  void onNextPressed() {
    getAttachments(task.attachmentsCurrentPage! + 1);
  }

  List<Attachment> get currentPageAttachments => task.attachments!
      .where((e) => e.page == task.attachmentsCurrentPage)
      .toList();

  bool get isLoaded => task.attachments != null;

  bool get hasAttachments =>
      task.attachments != null && task.attachments!.isNotEmpty;

  @override
  List<Object?> get props => [
        task,
        isAttachmentsLoading,
      ];
}
