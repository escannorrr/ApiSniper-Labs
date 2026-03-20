import 'dart:math';

class CommandMessages {
  static final List<String> loadingMessages = [
    'Initializing command protocol...',
    'Scanning target systems...',
    'Recon team gathering intel...',
    'Analyzing mission parameters...',
    'Deploying reconnaissance units...',
    'Establishing secure uplink...',
    'Decrypting satellite data...',
    'Synchronizing tactical displays...',
    'Calibrating orbital sensors...',
    'Processing battlefield data...',
  ];

  static final List<String> successMessages = [
    'Mission accomplished.',
    'Target secured successfully.',
    'Operation completed successfully.',
    'All systems operational.',
    'Objective reached.',
    'Secure connection established.',
    'Data exfiltration complete.',
    'Infiltration successful.',
  ];

  static final List<String> errorMessages = [
    'Mission failed. Request aborted.',
    'Target unreachable.',
    'Connection to command center lost.',
    'Operation compromised.',
    'System breach detected.',
    'Signal interference detected.',
    'Authorization denied.',
    'Critical system failure.',
  ];

  static final List<String> emptyMessages = [
    'Command center awaiting instructions.',
    'No missions deployed yet.',
    'No targets detected in this sector.',
    'Sector is clear for now.',
    'Awaiting further intel.',
    'Intelligence report: No data found.',
  ];

  static String getRandomLoadingMessage() => _getRandomMessage(loadingMessages);
  static String getRandomSuccessMessage() => _getRandomMessage(successMessages);
  static String getRandomErrorMessage() => _getRandomMessage(errorMessages);
  static String getRandomEmptyMessage() => _getRandomMessage(emptyMessages);

  static String _getRandomMessage(List<String> messages) {
    if (messages.isEmpty) return 'Executing command...';
    return messages[Random().nextInt(messages.length)];
  }
}
