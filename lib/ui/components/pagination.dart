import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int current;
  final int total;
  final bool isDataLoading;
  final VoidCallback onPrevPressed;
  final VoidCallback onNextPressed;

  const Pagination({
    super.key,
    required this.current,
    required this.total,
    required this.isDataLoading,
    required this.onPrevPressed,
    required this.onNextPressed,
  });

  VoidCallback? getOnNextPressed() {
    return current < total
        ? isDataLoading
            ? () {}
            : () => onNextPressed()
        : null;
  }

  VoidCallback? getOnPrevPressed() {
    return current > 1
        ? isDataLoading
            ? () {}
            : () => onPrevPressed()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return total > 1
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getOnPrevPressed() == null
                  ? const SizedBox(width: 48)
                  : IconButton(
                      onPressed: getOnPrevPressed(),
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$current / $total',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              getOnNextPressed() == null
                  ? const SizedBox(width: 48)
                  : IconButton(
                      onPressed: getOnNextPressed(),
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
            ],
          )
        : const SizedBox.shrink();
  }
}
