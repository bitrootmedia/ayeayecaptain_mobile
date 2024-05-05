import 'package:flutter/material.dart';

class BlockCard extends StatelessWidget {
  final Widget content;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BlockCard({
    super.key,
    required this.content,
    required this.isEditing,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 26,
            width: 34,
            child: Center(
              child: Icon(
                Icons.drag_indicator,
                color: Color(0xff94a3b8),
                size: 22,
              ),
            ),
          ),
          Expanded(child: content),
          const SizedBox(width: 4),
          Column(
            children: [
              getButton(
                icon: Icons.create,
                onPressed: onEdit,
              ),
              if (isEditing)
                getButton(
                  icon: Icons.delete,
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget getButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 18,
          ),
        ),
      ),
    );
  }
}
