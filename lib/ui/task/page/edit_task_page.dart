import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
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
  late List<Block> _blocks;

  @override
  void initState() {
    _blocks = widget.task.blocks;
    super.initState();
  }

  void _updateBlock(Block oldBlock, Block newBlock) {
    setState(() {
      _blocks[_blocks.indexOf(oldBlock)] = newBlock;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = di<Store<AppState>>();

    return Scaffold(
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
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ..._blocks.map(
              (e) => e is MarkdownBlock
                  ? MarkdownBlockCard(
                      block: e,
                      onBlockChanged: _updateBlock,
                    )
                  : e is ImageBlock
                      ? ImageBlockCard(
                          block: e,
                          onBlockChanged: _updateBlock,
                          taskId: widget.task.id,
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
