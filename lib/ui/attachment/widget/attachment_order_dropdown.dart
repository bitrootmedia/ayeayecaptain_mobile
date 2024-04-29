import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/task/entity/task.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class AttachmentOrderDropdown extends StatefulWidget {
  final Task task;

  const AttachmentOrderDropdown({
    super.key,
    required this.task,
  });

  @override
  State<AttachmentOrderDropdown> createState() =>
      _AttachmentOrderDropdownState();
}

class _AttachmentOrderDropdownState extends State<AttachmentOrderDropdown> {
  final store = di<Store<AppState>>();
  OverlayEntry? _menu;
  late Task task;

  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AttachmentOrderDropdown oldWidget) {
    task = widget.task;
    super.didUpdateWidget(oldWidget);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeMenu,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: offset.dy + size.height + 5,
            left: offset.dx,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getMenuItem(orderByCreatedAt),
                    getMenuItem(orderByOwner),
                    getMenuItem(orderByProject),
                    getMenuItem(orderByTitle),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getOrderByText(String orderBy) {
    switch (orderBy) {
      case orderByCreatedAt:
        return 'Created at';
      case orderByOwner:
        return 'User';
      case orderByProject:
        return 'Project';
      case orderByTitle:
        return 'Title';
      default:
        throw Exception('Unknown order by field');
    }
  }

  void _openMenu() {
    _menu = _createOverlayEntry();
    Overlay.of(context).insert(_menu!);
  }

  void _closeMenu() {
    _menu!.remove();
    _menu = null;
  }

  Widget getMenuItem(String orderBy) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _closeMenu();
        store.dispatch(GetTaskAttachmentsAction(
          taskId: task.id,
          page: task.attachmentsCurrentPage!,
          pageSize: task.attachmentsPageSize!,
          orderBy: orderBy,
          shouldReset: true,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          getOrderByText(orderBy),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _menu == null ? _openMenu() : _closeMenu();
      },
      child: Row(
        children: [
          Text(
            getOrderByText(task.attachmentsOrderBy),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.sort_rounded),
        ],
      ),
    );
  }
}
