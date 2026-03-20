import 'package:flutter/material.dart';

enum CommandMessageType { success, error, info }

class CommandSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    CommandMessageType type = CommandMessageType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    IconData icon;
    Color color;

    switch (type) {
      case CommandMessageType.success:
        icon = Icons.gps_fixed;
        color = Colors.greenAccent;
        break;
      case CommandMessageType.error:
        icon = Icons.warning_amber_rounded;
        color = Colors.redAccent;
        break;
      case CommandMessageType.info:
        icon = Icons.satellite_alt;
        color = Colors.blueAccent;
        break;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontFamily: 'Courier',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900]?.withOpacity(0.9) ?? Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        duration: duration,
        elevation: 10,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: CommandMessageType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: CommandMessageType.error);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: CommandMessageType.info);
  }
}
