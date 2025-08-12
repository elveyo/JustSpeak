import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:frontend/config/agora_config.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  RtcEngine? _engine;

  // 🔹 Inicijalizacija engine-a
  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: AgoraConfig.appId));
    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine!.enableVideo();
    await _engine!.enableAudio();
    print("✅ Agora engine initialized successfully");
  }

  Future<void> joinChannel(String channelName, String token) async {
    await _engine!.joinChannel(
      token: token,
      channelId: AgoraConfig.defaultChannelName,
      uid: AgoraConfig.uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine!.leaveChannel();
    print("🚪 Napustio kanal");
  }

  Future<void> toggleMic(bool mute) async {
    await _engine!.muteLocalAudioStream(mute);
    print(mute ? "🎙 Mikrofon isključen" : "🎙 Mikrofon uključen");
  }

  Future<void> toggleCamera(bool mute) async {
    await _engine!.muteLocalVideoStream(mute);
    print(mute ? "📷 Kamera isključena" : "📷 Kamera uključena");
  }

  Future<void> dispose() async {
    await _engine?.release();
    _engine = null;
    print("🛑 Agora engine ugašen");
  }

  RtcEngine? get engine => _engine;
}
