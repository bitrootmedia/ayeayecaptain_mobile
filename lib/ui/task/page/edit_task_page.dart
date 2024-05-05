import 'dart:io';

import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/utils/validation.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:ayeayecaptain_mobile/domain/file/interface/file_repository.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/attachment/widget/attachment_section.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_text_field.dart';
import 'package:ayeayecaptain_mobile/ui/components/unfocusable.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/checklist_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/image_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/markdown_block_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final store = di<Store<AppState>>();
  late Task _clonedTask;
  bool _isUploading = false;
  bool _isTitleEditing = false;

  @override
  void initState() {
    _clonedTask = widget.task.clone();
    super.initState();
  }

  void _deleteBlock(Block block) {
    setState(() {
      _clonedTask.blocks.remove(block);
    });
  }

  void _addBlock(Block block) {
    setState(() {
      _clonedTask.blocks.add(block);
    });
  }

  void _reorderBlocks(int oldIndex, int newIndex) {
    setState(() {
      final block = _clonedTask.blocks.removeAt(oldIndex);
      if (oldIndex < newIndex) {
        newIndex--;
      }
      _clonedTask.blocks.insert(newIndex, block);
    });
  }

  void _save() {
    store.dispatch(PartiallyUpdateTaskAction(
      taskId: _clonedTask.id,
      title: _clonedTask.title,
      blocks: _clonedTask.blocks,
    ));
  }

  Future<void> _pickFile(Task task) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _isUploading = true;
      });
      final request = await di<FileRepository>().uploadFile(
        profile: store.state.profileState.selected!,
        taskId: widget.task.id,
        file: File(result.files.single.path!),
      );
      setState(() {
        _isUploading = false;
      });
      if (request.wasSuccessful) {
        _resetAttachments(task);
      }
    }
  }

  void _resetAttachments(Task task) {
    store.dispatch(GetTaskAttachmentsAction(
      taskId: widget.task.id,
      page: task.attachmentsCurrentPage ?? 1,
      pageSize: attachmentsPageSize,
      orderBy: task.attachmentsOrderBy,
      shouldReset: true,
    ));
  }

  void _updateTitle(String value) {
    _clonedTask = _clonedTask.copyWith(title: value);
  }

  @override
  Widget build(BuildContext context) {
    return Unfocusable(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => store.dispatch(ClosePageAction()),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isTitleEditing
                    ? CustomTextField(
                        label: 'Title',
                        initialValue: widget.task.title,
                        validator: isNotEmptyValidator,
                        onChanged: _updateTitle,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTitleEditing = true;
                          });
                        },
                        child: Text(
                          _clonedTask.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              ReorderableListView(
                onReorder: _reorderBlocks,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _clonedTask.blocks
                    .map(
                      (e) => e is MarkdownBlock
                          ? MarkdownBlockCard(
                              key: ObjectKey(e),
                              block: e,
                              onBlockDeleted: _deleteBlock,
                            )
                          : e is ImageBlock
                              ? ImageBlockCard(
                                  key: ObjectKey(e),
                                  block: e,
                                  onBlockDeleted: _deleteBlock,
                                  taskId: _clonedTask.id,
                                )
                              : ChecklistBlockCard(
                                  key: ObjectKey(e),
                                  block: e as ChecklistBlock,
                                  onBlockDeleted: _deleteBlock,
                                ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _addBlock(MarkdownBlock.empty()),
                    icon: const Icon(Icons.format_align_left_rounded),
                  ),
                  IconButton(
                    onPressed: () => _addBlock(ImageBlock.empty()),
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () => _addBlock(ChecklistBlock.empty()),
                    icon: const Icon(Icons.checklist_rounded),
                  ),
                  _isUploading
                      ? const SizedBox(
                          width: 48,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () => _pickFile(widget.task),
                          icon: const Icon(Icons.attach_file_rounded),
                        ),
                ],
              ),
              const SizedBox(height: 24),
              AttachmentSection(taskId: widget.task.id),
            ],
          ),
        ),
      ),
    );
  }
}
