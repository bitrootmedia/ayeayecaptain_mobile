import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/block_card.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownBlockCard extends StatefulWidget {
  final MarkdownBlock block;
  final void Function(Block, Block) onBlockChanged;
  final void Function(Block) onBlockDeleted;

  const MarkdownBlockCard({
    super.key,
    required this.block,
    required this.onBlockChanged,
    required this.onBlockDeleted,
  });

  @override
  State<MarkdownBlockCard> createState() => _MarkdownBlockCardState();
}

class _MarkdownBlockCardState extends State<MarkdownBlockCard> {
  bool _isEditing = false;
  late String _value;

  @override
  void initState() {
    _value = widget.block.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlockCard(
      isEditing: _isEditing,
      onEdit: () {
        setState(() {
          _isEditing = true;
        });
      },
      onSave: () {
        widget.onBlockChanged(
          widget.block,
          widget.block.copyWith(content: _value),
        );
        setState(() {
          _isEditing = false;
        });
      },
      onCancel: () {
        setState(() {
          _value = widget.block.content;
          _isEditing = false;
        });
      },
      onDelete: () {
        widget.onBlockDeleted(widget.block);
      },
      content: _isEditing
          ? MarkdownTextInput(
              (String value) => _value = value,
              _value,
              maxLines: 6,
              actions: MarkdownType.values,
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: widget.block.content.isEmpty
                    ? const Text(
                        'No text',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    : MarkdownBody(data: widget.block.content),
              ),
            ),
    );
  }
}
