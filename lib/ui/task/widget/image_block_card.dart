import 'dart:io';

import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/block.dart';
import 'package:ayeayecaptain_mobile/domain/block/entity/image_block.dart';
import 'package:ayeayecaptain_mobile/domain/file/interface/file_repository.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/ui/task/widget/block_card.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:image_picker/image_picker.dart';

final _imagePicker = ImagePicker();

class ImageBlockCard extends StatefulWidget {
  final ImageBlock block;
  final void Function(Block, Block) onBlockChanged;
  final String taskId;

  const ImageBlockCard({
    super.key,
    required this.block,
    required this.onBlockChanged,
    required this.taskId,
  });

  @override
  State<ImageBlockCard> createState() => _ImageBlockCardState();
}

class _ImageBlockCardState extends State<ImageBlockCard> {
  final profile = di<Store<AppState>>().state.profileState.selected!;
  bool _isEditing = false;
  String? _newImagePath;

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      final request = await di<FileRepository>().uploadFile(
        profile: profile,
        taskId: widget.taskId,
        file: File(image.path),
      );
      if (request.wasSuccessful) {
        setState(() {
          _newImagePath = request.result!;
        });
      }
    }
  }

  Widget _getImage(
    String src, {
    int? cacheHeight,
  }) {
    return Image.network(
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
    );
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
        if (_newImagePath != null) {
          widget.onBlockChanged(
            widget.block,
            widget.block.copyWith(path: _newImagePath),
          );
          _newImagePath = null;
        }
        setState(() {
          _isEditing = false;
        });
      },
      onDelete: () {},
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            height: 150,
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
                      if (_newImagePath != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getImage(
                                '${profile.backendUrl}/$_newImagePath',
                                cacheHeight: 60,
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _newImagePath = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                : widget.block.path.isEmpty
                    ? const Center(
                        child: Text(
                          'No image',
                          style: TextStyle(color: Colors.grey),
                        ),
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
