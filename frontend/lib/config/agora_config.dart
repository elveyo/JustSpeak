class AgoraConfig {
  // Replace with your actual Agora App ID
  static const String appId = 'af10554483784913b19f5fe6fcf9595b';
  static const String token =
      "007eJxTYDh1PUix63D+VS6mnOqZqzWTG8/tmj/rh+j8PcW2n01qBQ4pMCSmGRqYmpqYWBibW5hYGhonGVqmmaalmqUlp1maWpomVaTNyGgIZGQ4s9uDkZEBAkF8doaS1OISQyNjBgYA0sAgpg==";

  // Agora Token Server URL (you'll need to set up a token server)
  static const String tokenServerUrl = 'https://your-token-server.com/token';

  // Default channel name for testing
  static const String defaultChannelName = 'test123';

  // Video call settings
  static const int uid = 0; // 0 means Agora will assign a random UID

  // Video dimensions
  static const int videoWidth = 640;
  static const int videoHeight = 480;
  static const int frameRate = 15;

  // Audio settings
  static const int audioSampleRate = 44100;
  static const int audioChannels = 1;

  // Get token from server (implement this based on your backend)
  static Future<String?> getToken(String channelName, int uid) async {
    try {
      // TODO: Implement token server call
      // For now, return null to use app ID only (for testing)
      return null;
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }
}
