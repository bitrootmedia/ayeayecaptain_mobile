import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/components/unfocusable.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/checklist_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/image_block_card.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/markdown_block_card.dart';
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
  late Task clonedTask;

  @override
  void initState() {
    clonedTask = widget.task.clone();
    super.initState();
  }

  void _updateBlock(Block oldBlock, Block newBlock) {
    setState(() {
      clonedTask.blocks[clonedTask.blocks.indexOf(oldBlock)] = newBlock;
    });
  }

  void _deleteBlock(Block block) {
    setState(() {
      clonedTask.blocks.remove(block);
    });
  }

  void _addBlock(Block block) {
    setState(() {
      clonedTask.blocks.add(block);
    });
  }

  void _reorderBlocks(int oldIndex, int newIndex) {
    setState(() {
      final block = clonedTask.blocks.removeAt(oldIndex);
      clonedTask.blocks.insert(newIndex, block);
    });
  }

  void _save() {
    store.dispatch(PartiallyUpdateTaskAction(
      clonedTask.id,
      clonedTask.blocks,
    ));
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
                child: Text(
                  clonedTask.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Blocks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ReorderableListView(
                onReorder: _reorderBlocks,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: clonedTask.blocks
                    .map(
                      (e) => e is MarkdownBlock
                          ? MarkdownBlockCard(
                              key: ObjectKey(e),
                              block: e,
                              onBlockChanged: _updateBlock,
                              onBlockDeleted: _deleteBlock,
                            )
                          : e is ImageBlock
                              ? ImageBlockCard(
                                  key: ObjectKey(e),
                                  block: e,
                                  onBlockChanged: _updateBlock,
                                  onBlockDeleted: _deleteBlock,
                                  taskId: clonedTask.id,
                                )
                              : ChecklistBlockCard(
                                  key: ObjectKey(e),
                                  block: e as ChecklistBlock,
                                  onBlockChanged: _updateBlock,
                                  onBlockDeleted: _deleteBlock,
                                ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _addBlock(const MarkdownBlock.empty()),
                    icon: const Icon(Icons.format_align_left_rounded),
                  ),
                  IconButton(
                    onPressed: () => _addBlock(const ImageBlock.empty()),
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () => _addBlock(const ChecklistBlock.empty()),
                    icon: const Icon(Icons.checklist_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
