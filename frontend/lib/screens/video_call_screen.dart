import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:frontend/services/agora_service.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String token;
  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.token,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final agoraService = AgoraService();

  final List<int> _remoteUids = [];
  int? _localUid = 0;

  @override
  void initState() {
    super.initState();
    _initAgoraAndJoin();
  }

  Future<void> _initAgoraAndJoin() async {
    try {
      await agoraService.initialize();

      if (agoraService.engine == null) {
        print("❌ Agora engine is null after initialization!");
        return;
      }

      // Register event handlers
      agoraService.engine!.registerEventHandler(
        RtcEngineEventHandler(
          onUserJoined: (connection, uid, elapsed) {
            print(
              "👤 REMOTE USER JOINED: $uid in channel: ${connection.channelId}",
            );
            setState(() {
              _remoteUids.add(uid);
            });
          },
          onUserOffline: (connection, uid, reason) {
            print(
              "🚪 REMOTE USER LEFT: $uid from channel: ${connection.channelId}",
            );
            setState(() {
              _remoteUids.remove(uid);
            });
          },
          onJoinChannelSuccess: (connection, elapsed) {
            print(
              "✅ SUCCESS: Joined channel: ${connection.channelId} (elapsed: ${elapsed}ms)",
            );
            setState(() {
              _localUid = connection.localUid!;
            });
          },
          onError: (errorCode, msg) {
            print("❌ AGORA ERROR: $errorCode - $msg");
          },
        ),
      );

      print("✅ Event handlers registered");
      await _startCall();
    } catch (e) {
      print("❌ Error in _initAgoraAndJoin: $e");
    }
  }

  Future<void> _startCall() async {
    if (agoraService.engine != null) {
      print('Agora engine is not null');
      print('Trying to join channel: "${widget.channelName}"');

      try {
        await agoraService.engine!.enableFaceDetection(false);
        await agoraService.joinChannel(widget.channelName, widget.token);
        await agoraService.engine!.startPreview();
        print('Successfully started call in channel: ${widget.channelName}');
      } catch (e) {
        print('Error starting call: $e');
      }
    } else {
      print('Agora engine is null!');
    }
  }

  @override
  void dispose() {
    agoraService.engine?.stopPreview();
    agoraService.leaveChannel();
    agoraService.engine?.release();
    agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channel: ${widget.channelName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {
              print("🔄 Manual refresh requested");
              setState(() {});
              // Try to rejoin channel
              if (agoraService.engine != null) {
                agoraService.leaveChannel().then((_) {
                  Future.delayed(Duration(seconds: 1), () {
                    agoraService.joinChannel(widget.channelName, widget.token);
                  });
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.call_end, color: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_localUid == null) {
            return Center(child: CircularProgressIndicator());
          }

          final allUids = [_localUid!, ..._remoteUids];
          final userCount = allUids.length;

          Widget buildVideo(int uid) {
            if (uid == _localUid) {
              // Local user
              return AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: agoraService.engine!,
                  canvas: VideoCanvas(uid: 0),
                ),
              );
            } else {
              // Remote user
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: agoraService.engine!,
                  canvas: VideoCanvas(uid: uid),
                  connection: RtcConnection(channelId: widget.channelName),
                ),
              );
            }
          }

          if (userCount == 1) {
            // Only local user, full screen
            return Center(child: buildVideo(_localUid!));
          } else if (userCount == 2) {
            // 2 users: split vertically
            return Column(
              children: [
                Expanded(child: buildVideo(allUids[0])),
                Expanded(child: buildVideo(allUids[1])),
              ],
            );
          } else if (userCount == 3) {
            // 3 users: 2 on top, 1 on bottom
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: buildVideo(allUids[0])),
                      Expanded(child: buildVideo(allUids[1])),
                    ],
                  ),
                ),
                Expanded(child: buildVideo(allUids[2])),
              ],
            );
          } else if (userCount >= 4) {
            // 4 users: 2x2 grid (show only first 4)
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: buildVideo(allUids[0])),
                      Expanded(child: buildVideo(allUids[1])),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: buildVideo(allUids[2])),
                      Expanded(child: buildVideo(allUids[3])),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // More than 4 users: show grid for first 4, and a message
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildVideo(allUids[0])),
                          Expanded(child: buildVideo(allUids[1])),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: buildVideo(allUids[2])),
                          Expanded(child: buildVideo(allUids[3])),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
