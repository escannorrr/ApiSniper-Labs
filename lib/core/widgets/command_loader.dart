import 'package:flutter/material.dart';
import '../utils/command_messages.dart';

class CommandLoader extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const CommandLoader({
    super.key,
    this.message,
    this.fullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayMessage = message ?? CommandMessages.getRandomLoadingMessage();
    
    final loader = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.satellite_alt,
              size: 16,
              color: Colors.greenAccent,
            ),
            const SizedBox(width: 8),
            Text(
              displayMessage,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'Courier',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(1),
          ),
          child: const LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        ),
      ],
    );

    if (!fullScreen) return loader;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(child: loader),
    );
  }
}
