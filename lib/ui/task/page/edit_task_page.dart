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
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/checklist_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/image_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/markdown_block_card.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class EditTaskPage extends StatefulWidget {
  final String taskId;

  const EditTaskPage({
    super.key,
    required this.taskId,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final store = di<Store<AppState>>();
  late Task _clonedTask;
  bool _isUploading = false;
  bool _isTitleEditing = false;
  bool _dataWasChanged = false;

  @override
  void initState() {
    if (store.state.taskState.task?.id == widget.taskId) {
      _clonedTask = store.state.taskState.task!.clone();
    }
    super.initState();
  }

  @override
  void dispose() {
    store.dispatch(UpdateTaskDataWasChangedAction(
      false,
      _clonedTask,
    ));
    super.dispose();
  }

  void _deleteBlock(Block block) {
    setState(() {
      _clonedTask.blocks.remove(block);
    });
    _checkIfDataWasChanged();
  }

  void _addBlock(Block block) {
    setState(() {
      _clonedTask.blocks.add(block);
    });
    _checkIfDataWasChanged();
  }

  void _reorderBlocks(int oldIndex, int newIndex) {
    setState(() {
      final block = _clonedTask.blocks.removeAt(oldIndex);
      if (oldIndex < newIndex) {
        newIndex--;
      }
      _clonedTask.blocks.insert(newIndex, block);
    });
    _checkIfDataWasChanged();
  }

  void _save() {
    store.dispatch(SaveTaskDetailsAction(
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
        taskId: widget.taskId,
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
      taskId: widget.taskId,
      page: task.attachmentsCurrentPage ?? 1,
      pageSize: attachmentsPageSize,
      orderBy: task.attachmentsOrderBy,
      shouldReset: true,
    ));
  }

  void _updateTitle(String value) {
    _clonedTask = _clonedTask.copyWith(title: value);
    _checkIfDataWasChanged();
  }

  void _checkIfDataWasChanged() {
    final task = store.state.taskState.task!;
    setState(() {
      _dataWasChanged = !Task.tasksIdentical(task, _clonedTask);
    });
    store.dispatch(UpdateTaskDataWasChangedAction(
      _dataWasChanged,
      _clonedTask,
    ));
  }

  void _onBackPressed() {
    if (_dataWasChanged) {
      store.dispatch(OpenAlertDialogAction(DialogConfig(
        content: 'Changes have not been saved.',
        actions: [
          DialogAction(
            label: 'It\'s ok',
            action: ClosePageAction(),
          ),
          DialogAction(
            label: 'Save changes',
            onPressed: _save,
          ),
        ],
      )));
    } else {
      store.dispatch(ClosePageAction());
    }
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
            onPressed: _onBackPressed,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            IconButton(
              onPressed: _save,
              icon: Icon(
                Icons.save,
                color: _dataWasChanged ? Colors.orange : Colors.white,
              ),
            ),
          ],
        ),
        body: StoreConnector<AppState, _ViewModel>(
          distinct: true,
          converter: (store) => _ViewModel(store, widget.taskId),
          onInitialBuild: (viewModel) {
            viewModel.loadData();
          },
          onWillChange: (prevVm, newVm) {
            if (prevVm != null && !prevVm.isLoaded && newVm.isLoaded) {
              _clonedTask = newVm.task!.clone();
            }
          },
          builder: (context, viewModel) {
            return viewModel.isLoaded
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _isTitleEditing
                              ? CustomTextField(
                                  label: 'Title',
                                  initialValue: viewModel.task!.title,
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
                                        checkIfDataWasChanged:
                                            _checkIfDataWasChanged,
                                      )
                                    : e is ImageBlock
                                        ? ImageBlockCard(
                                            key: ObjectKey(e),
                                            block: e,
                                            onBlockDeleted: _deleteBlock,
                                            taskId: _clonedTask.id,
                                            checkIfDataWasChanged:
                                                _checkIfDataWasChanged,
                                          )
                                        : ChecklistBlockCard(
                                            key: ObjectKey(e),
                                            block: e as ChecklistBlock,
                                            onBlockDeleted: _deleteBlock,
                                            checkIfDataWasChanged:
                                                _checkIfDataWasChanged,
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
                              onPressed: () =>
                                  _addBlock(ChecklistBlock.empty()),
                              icon: const Icon(Icons.checklist_rounded),
                            ),
                            _isUploading
                                ? const SizedBox(
                                    width: 48,
                                    child: Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () => _pickFile(viewModel.task!),
                                    icon: const Icon(Icons.attach_file_rounded),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AttachmentSection(taskId: widget.taskId),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class _ViewModel with EquatableMixin {
  final Store<AppState> _store;
  final Task? task;
  final String taskId;

  _ViewModel(
    this._store,
    this.taskId,
  ) : task = _store.state.taskState.task;

  bool get isLoaded => task?.id == taskId;

  void loadData() {
    if (!isLoaded) {
      _store.dispatch(GetTaskAction(taskId));
    }
  }

  @override
  List<Object?> get props => [task];
}
