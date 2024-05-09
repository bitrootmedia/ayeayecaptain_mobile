import 'dart:io';

import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/file/interface/file_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/block_card.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

final _imagePicker = ImagePicker();

class ImageBlockCard extends StatefulWidget {
  final ImageBlock block;
  final void Function(Block) onBlockDeleted;
  final String taskId;
  final VoidCallback checkIfDataWasChanged;

  const ImageBlockCard({
    super.key,
    required this.block,
    required this.onBlockDeleted,
    required this.taskId,
    required this.checkIfDataWasChanged,
  });

  @override
  State<ImageBlockCard> createState() => _ImageBlockCardState();
}

class _ImageBlockCardState extends State<ImageBlockCard> {
  final store = di<Store<AppState>>();
  final profile = di<Store<AppState>>().state.profileState.selected!;
  bool _isEditing = false;
  bool _isUploading = false;

  @override
  void initState() {
    _isEditing = widget.block.path.isEmpty;
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _isUploading = true;
      });
      final request = await di<FileRepository>().uploadFile(
        profile: profile,
        taskId: widget.taskId,
        file: File(image.path),
      );
      setState(() {
        _isUploading = false;
      });
      if (request.wasSuccessful) {
        setState(() {
          widget.block.path = request.result!;
          _isEditing = false;
        });
        _resetAttachments();
        widget.checkIfDataWasChanged();
      }
    }
  }

  void _resetAttachments() {
    final task = store.state.taskState.task!;
    store.dispatch(GetTaskAttachmentsAction(
      taskId: widget.taskId,
      page: task.attachmentsCurrentPage ?? 1,
      pageSize: attachmentsPageSize,
      orderBy: task.attachmentsOrderBy,
      shouldReset: true,
    ));
  }

  Widget _getImage(
    String src, {
    int? cacheHeight,
  }) {
    return GestureDetector(
      onTap: () => store.dispatch(OpenViewImagePageAction(src)),
      child: Image.network(
        src,
        fit: BoxFit.contain,
        cacheHeight: cacheHeight,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
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
          child: SizedBox(
            height: widget.block.path.isEmpty && !_isEditing ? null : 150,
            child: _isEditing
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Take a photo or select from gallery',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_rounded),
                          ),
                          IconButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.image),
                          ),
                        ],
                      ),
                      if (_isUploading) const Text('Uploading...'),
                    ],
                  )
                : widget.block.path.isEmpty
                    ? const Text(
                        'No image',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    : _getImage(
                        '${profile.backendUrl}/${widget.block.path}',
                        cacheHeight: 150,
                      ),
          ),
        ),
      ),
    );
  }
}
