import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const GenerateButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.4,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
        label: const Text('Generate'),
      ),
    );
  }
}
