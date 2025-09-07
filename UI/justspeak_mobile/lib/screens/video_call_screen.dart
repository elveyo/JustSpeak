import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:frontend/services/agora_service.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String token;
  final int remainingSeconds;
  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.token,
    required this.remainingSeconds,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final agoraService = AgoraService();
  Map<int, String> _remoteUsers = {}; // uid → userAccount
  Set<int> _joinedUids = {}; // Track all joined UIDs
  int? _localUid;
  bool _micMuted = false;
  bool _camMuted = false;
  int _remainingSeconds = 0;

  // Countdown timer
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndJoin();
    _startCountdown();
  }

  void _startCountdown() {
    _remainingSeconds = widget.remainingSeconds;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _requestPermissionsAndJoin() async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (!statuses.values.every((status) => status.isGranted)) {
      print("❌ Camera or microphone permission denied!");
      return;
    }
    _initAgoraAndJoin();
  }

  Future<void> _initAgoraAndJoin() async {
    try {
      await agoraService.initialize();
      if (agoraService.engine == null) {
        print("❌ Agora engine is null after initialization!");
        return;
      }
      await agoraService.engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 30,
          bitrate: 0,
        ),
      );
      agoraService.engine!.registerEventHandler(
        RtcEngineEventHandler(
          onUserJoined: (connection, uid, elapsed) async {
            print("User joined: $uid");
            // Add to joined set
            setState(() {
              _joinedUids.add(uid);
            });
            // Try to get user info (if available)
            try {
              final userInfo = await agoraService.engine!.getUserInfoByUid(uid);
              if (userInfo.userAccount != null &&
                  userInfo.userAccount!.isNotEmpty) {
                setState(() {
                  _remoteUsers[uid] = userInfo.userAccount!;
                });
              }
            } catch (e) {
              // ignore if not available
            }
          },
          onUserOffline: (connection, uid, reason) {
            print("User offline: $uid");
            setState(() {
              _joinedUids.remove(uid);
              _remoteUsers.remove(uid);
            });
          },
          onJoinChannelSuccess: (connection, elapsed) {
            print("Join channel success: ${connection.localUid}");
            setState(() {
              _localUid = connection.localUid!;
              _joinedUids.add(_localUid!);
            });
          },
          onUserInfoUpdated: (uid, userInfo) {
            print("User info updated: ${userInfo.userAccount}");
            setState(() {
              _remoteUsers[uid] = userInfo.userAccount ?? '';
            });
          },
          onRejoinChannelSuccess: (connection, elapsed) {
            print("Rejoin channel success: ${connection.localUid}");
            setState(() {
              if (connection.localUid != null) {
                _localUid = connection.localUid!;
                _joinedUids.add(_localUid!);
              }
            });
          },
          onConnectionStateChanged: (connection, state, reason) {
            print("Connection state changed: $state, reason: $reason");
            // Optionally handle reconnection logic here
          },
          onError: (errorCode, msg) {
            print("❌ AGORA ERROR: $errorCode - $msg");
          },
        ),
      );
      await _startCall();
    } catch (e) {
      print("❌ Error initializing Agora: $e");
    }
  }

  Future<void> _startCall() async {
    if (agoraService.engine == null) return;
    await agoraService.engine!.enableVideo();
    await agoraService.engine!.startPreview();
    await agoraService.joinChannel(widget.channelName, widget.token);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    agoraService.engine?.stopPreview();
    agoraService.leaveChannel();
    agoraService.engine?.release();
    agoraService.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    setState(() => _micMuted = !_micMuted);
    await agoraService.toggleMic(_micMuted);
  }

  Future<void> _toggleCamera() async {
    setState(() => _camMuted = !_camMuted);
    await agoraService.toggleCamera(_camMuted);
  }

  Widget _buildVideo(int uid, {bool showLabel = true}) {
    final isLocal = uid == _localUid;
    final videoWidget =
        isLocal
            ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: agoraService.engine!,
                canvas: VideoCanvas(
                  uid: 0,
                  sourceType: VideoSourceType.videoSourceCamera,
                ),
              ),
            )
            : AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: agoraService.engine!,
                canvas: VideoCanvas(uid: uid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            );
    return Stack(
      children: [
        Positioned.fill(child: videoWidget),
        if (showLabel)
          Positioned(
            left: 8,
            top: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isLocal
                        ? "You"
                        : (_remoteUsers[uid] != null &&
                                _remoteUsers[uid]!.isNotEmpty
                            ? "${_remoteUsers[uid]}"
                            : "UID: $uid"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
      ],
    );
  }

  int _getCrossAxisCount(int userCount) {
    if (userCount == 2) return 2;
    if (userCount <= 4) return 2;
    if (userCount <= 9) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Video Call",
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (_localUid == null) {
                return const Center(child: CircularProgressIndicator());
              }
              // Use _joinedUids to track all currently joined users (including local)
              final remoteUids =
                  _joinedUids.where((uid) => uid != _localUid).toList();
              final allUids = [_localUid!, ...remoteUids];
              final userCount = allUids.length;

              if (userCount == 2) {
                final remoteUid =
                    remoteUids.isNotEmpty ? remoteUids.first : _localUid!;
                final localUid = _localUid!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        child: _buildVideo(remoteUid),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 120,
                              height: 180,
                              color: Colors.black,
                              child: _buildVideo(localUid, showLabel: true),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (userCount == 4) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: _buildVideo(allUids[0]),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: _buildVideo(allUids[1]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: _buildVideo(allUids[2]),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: _buildVideo(allUids[3]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(userCount),
                    childAspectRatio: 9 / 16,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: allUids.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.black,
                      child: _buildVideo(allUids[index]),
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _micMuted ? Icons.mic_off : Icons.mic,
                        color: _micMuted ? Colors.red : Colors.white,
                        size: 32,
                      ),
                      onPressed: _toggleMic,
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      icon: Icon(
                        _camMuted ? Icons.videocam_off : Icons.videocam,
                        color: _camMuted ? Colors.red : Colors.white,
                        size: 32,
                      ),
                      onPressed: _toggleCamera,
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                        size: 36,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Leave Call',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
