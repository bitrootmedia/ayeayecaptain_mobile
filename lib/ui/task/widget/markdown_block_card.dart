import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/markdown_block.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/block_card.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownBlockCard extends StatefulWidget {
  final MarkdownBlock block;
  final void Function(Block) onBlockDeleted;
  final VoidCallback checkIfDataWasChanged;

  const MarkdownBlockCard({
    super.key,
    required this.block,
    required this.onBlockDeleted,
    required this.checkIfDataWasChanged,
  });

  @override
  State<MarkdownBlockCard> createState() => _MarkdownBlockCardState();
}

class _MarkdownBlockCardState extends State<MarkdownBlockCard> {
  bool _isEditing = false;

  @override
  void initState() {
    _isEditing = widget.block.content.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlockCard(
      isEditing: _isEditing,
      onEdit: () {
        setState(() {
          _isEditing = !_isEditing;
        });
      },
      onDelete: () {
        widget.onBlockDeleted(widget.block);
      },
      content: _isEditing
          ? MarkdownTextInput(
              (String value) {
                widget.block.content = value;
                widget.checkIfDataWasChanged();
              },
              widget.block.content,
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
                    : MarkdownBody(
                        data: widget.block.content,
                        onTapLink: (text, href, title) async {
                          if (href != null && href.isNotEmpty) {
                            final url = Uri.parse(href);
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          }
                        },
                      ),
              ),
            ),
    );
  }
}
