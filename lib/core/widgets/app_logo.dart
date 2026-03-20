import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final bool showText;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width = 160,
    this.showText = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // If we only want the icon (e.g. for collapsed sidebar)
    // In a real scenario, we might have a separate icon-only file
    // But for now, we'll use a ClipRect or just a specific icon if available.
    // Given the prompt's simplicity, we'll assume the logo is clear enough or handled via alignment/fit.
    // However, the prompt specifically mention:
    // "Full sidebar: Show full logo (icon + text)"
    // "Collapsed sidebar: Show only the icon portion of the logo"
    
    // For this implementation, we'll use the single image and adjust the view.
    // To show only the icon (which is usually on the left), we can use a Sizedbox with alignment.
    
    if (!showText) {
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo/apisniper_logo.png'),
            fit: BoxFit.none,
            alignment: Alignment.centerLeft,
            scale: 12.0, // Scale it down to focus on the icon
          ),
        ),
      );
    }

    return Image.asset(
      'assets/images/logo/apisniper_logo.png',
      width: width,
      fit: fit,
    );
  }
}
