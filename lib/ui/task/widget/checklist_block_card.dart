import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/checklist_block_element.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_text_field.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/block_card.dart';
import 'package:flutter/material.dart';

class ChecklistBlockCard extends StatefulWidget {
  final ChecklistBlock block;
  final void Function(Block) onBlockDeleted;
  final VoidCallback checkIfDataWasChanged;

  const ChecklistBlockCard({
    super.key,
    required this.block,
    required this.onBlockDeleted,
    required this.checkIfDataWasChanged,
  });

  @override
  State<ChecklistBlockCard> createState() => _ChecklistBlockCardState();
}

class _ChecklistBlockCardState extends State<ChecklistBlockCard> {
  bool _isEditing = false;

  @override
  void initState() {
    _isEditing = widget.block.isEmpty;
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
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _isEditing
              ? Column(
                  children: [
                    CustomTextField(
                      label: 'Checklist title',
                      initialValue: widget.block.title,
                      onChanged: (value) {
                        widget.block.title = value.trim();
                        widget.checkIfDataWasChanged();
                      },
                    ),
                    ...widget.block.elements.map(
                      (e) => Padding(
                        key: ObjectKey(e),
                        padding: const EdgeInsets.only(top: 12, left: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Checkbox title',
                                initialValue: e.label,
                                onChanged: (value) {
                                  e.label = value.trim();
                                  widget.checkIfDataWasChanged();
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.block.elements.remove(e);
                                });
                                widget.checkIfDataWasChanged();
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.block.elements
                              .add(ChecklistBlockElement.empty());
                        });
                        widget.checkIfDataWasChanged();
                      },
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                )
              : widget.block.isEmpty
                  ? const Text(
                      'No checklist',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.block.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...widget.block.elements.map(
                          (e) => checklistItem(
                              title: e.label,
                              isChecked: e.checked,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    e.checked = value;
                                  }
                                });
                                widget.checkIfDataWasChanged();
                              }),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget checklistItem({
    required String title,
    required bool isChecked,
    required Function(bool?) onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
        ),
        Text(title),
      ],
    );
  }
}
