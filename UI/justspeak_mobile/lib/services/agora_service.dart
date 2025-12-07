import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:frontend/config/agora_config.dart';
import 'package:frontend/services/auth_service.dart';

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
    if (_engine == null) {
      print("❌ Cannot join channel: Engine is null");
      return;
    }
    final user = AuthService().user;
    if (user == null) {
      print("❌ Cannot join channel: User is null");
      return;
    }
    
    print("🔄 Joining channel with account: ${user.id}:${user.fullName}");

    try {
      await _engine!.joinChannelWithUserAccount(
        token: token,
        channelId: channelName,
        userAccount: "${user.id}:${user.fullName}",
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print("❌ Error joining channel: $e");
      rethrow;
    }
  }

  Future<void> leaveChannel() async {
    if (_engine == null) return;
    try {
      await _engine!.leaveChannel();
      print("🚪 Napustio kanal");
    } catch (e) {
      print("❌ Error leaving channel: $e");
    }
  }

  Future<void> toggleMic(bool mute) async {
    if (_engine == null) return;
    try {
      await _engine!.muteLocalAudioStream(mute);
      print(mute ? "🎙 Mikrofon isključen" : "🎙 Mikrofon uključen");
    } catch (e) {
      print("❌ Error toggling mic: $e");
    }
  }

  Future<void> toggleCamera(bool mute) async {
    if (_engine == null) return;
    try {
      await _engine!.muteLocalVideoStream(mute);
      print(mute ? "📷 Kamera isključena" : "📷 Kamera uključena");
    } catch (e) {
      print("❌ Error toggling camera: $e");
    }
  }

  Future<void> dispose() async {
    await _engine?.release();
    _engine = null;
    print("🛑 Agora engine ugašen");
  }

  RtcEngine? get engine => _engine;
}
