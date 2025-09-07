class AgoraConfig {
  // Replace with your actual Agora App ID
  static const String appId = 'af10554483784913b19f5fe6fcf9595b';

  // Video call settings
  static const int uid = 0; // 0 means Agora will assign a random UID

  // Video dimensions
  static const int videoWidth = 640;
  static const int videoHeight = 480;
  static const int frameRate = 15;

  // Audio settings
  static const int audioSampleRate = 44100;
  static const int audioChannels = 1;
}
