import 'package:flutter/material.dart';
import '../utils/command_messages.dart';

class CommandEmptyState extends StatelessWidget {
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const CommandEmptyState({
    super.key,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final displayMessage = message ?? CommandMessages.getRandomEmptyMessage();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radar_rounded,
              size: 64,
              color: Colors.greenAccent.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'NO TARGETS DETECTED',
              style: TextStyle(
                color: Colors.greenAccent.withOpacity(0.5),
                fontFamily: 'Courier',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.greenAccent.withOpacity(0.4),
                fontFamily: 'Courier',
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_task, color: Colors.greenAccent),
                label: Text(
                  actionLabel!,
                  style: const TextStyle(color: Colors.greenAccent),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.greenAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
