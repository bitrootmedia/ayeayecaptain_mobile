import 'package:flutter/material.dart';

class BlockCard extends StatelessWidget {
  final Widget content;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const BlockCard({
    super.key,
    required this.content,
    required this.isEditing,
    required this.onEdit,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.drag_indicator,
              color: Color(0xff94a3b8),
              size: 18,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(child: content),
          const SizedBox(width: 4),
          Column(
            children: [
              if (isEditing)
                getButton(
                  icon: Icons.check,
                  onPressed: onSave,
                ),
              if (isEditing)
                getButton(
                  icon: Icons.close,
                  onPressed: onDelete,
                ),
              if (!isEditing)
                getButton(
                  icon: Icons.create,
                  onPressed: onEdit,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 14,
          ),
        ),
      ),
    );
  }
}
