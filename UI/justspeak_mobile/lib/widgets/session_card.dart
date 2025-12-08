import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/screens/session_details_screen.dart';
import 'package:frontend/screens/video_call_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'user_avatar.dart';

class SessionCard extends StatelessWidget {
  final int sessionId;
  final String channelName;
  final String imageUrl;
  final String name;
  final String sessionTitle;
  final int languageId;
  final int levelId;
  final String date;
  final String time;
  final bool isActive;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCompleted;
  final String? note;
  final VoidCallback? onSessionCompleted; // Callback to refresh sessions

  const SessionCard({
    super.key,
    required this.sessionId,
    required this.channelName,
    required this.imageUrl,
    required this.name,
    required this.sessionTitle,
    required this.languageId,
    required this.levelId,
    required this.date,
    required this.time,
    required this.isActive,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
    this.note,
    this.onSessionCompleted,
  });

  Future<void> joinChannel(BuildContext context) async {
    String role = AuthService().user!.role;
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );

    try {
      DateTime actualStartTime = startTime;
      DateTime actualEndTime = endTime;
      bool actualIsActive = isActive; // Track the real active status from backend
      bool needsRefetch = false;
      
      if (role == "Tutor" && !isActive) {
        bool started = await sessionProvider.startSession(sessionId);
        if (!started) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to start session")),
          );
          return;
        }
        needsRefetch = true;
      } else if (role == "Student") {
        // Always refetch for student to check if session has started since list load
        needsRefetch = true;
      }
      
      // Fetch updated session times if needed
      if (needsRefetch) {
        try {
          // Small delay to ensure database is updated if we just started it
          if (role == "Tutor") {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          
          final sessions = role == "Tutor" 
              ? await sessionProvider.getTutorSessions()
              : await sessionProvider.getStudentSessions();
          
          final updatedSession = sessions.firstWhere((s) => s.id == sessionId);
          actualStartTime = updatedSession.startTime;
          actualEndTime = updatedSession.endTime;
          actualIsActive = updatedSession.isActive; // Update active status
          
          print("🔄 Fetched updated session - Active: $actualIsActive, Start: $actualStartTime, End: $actualEndTime");
        } catch (e) {
          print("❌ Error fetching updated session: $e");
          // Fallback for tutor: calculate based on original duration
          if (role == "Tutor") {
            final duration = endTime.difference(startTime);
            actualStartTime = DateTime.now();
            actualEndTime = actualStartTime.add(duration);
            actualIsActive = true;
          }
        }
      }

      String token = await sessionProvider.getToken(channelName);
      
      int sessionDurationSeconds;
      final now = DateTime.now().toUtc(); // Use UTC for comparison
      
      // Helper to ensure time is treated as UTC
      DateTime toUtc(DateTime dt) {
        if (dt.isUtc) return dt;
        return DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
      }
      
      final startUtc = toUtc(actualStartTime);
      final endUtc = toUtc(actualEndTime);
      
      if (role == "Tutor") {
        // Tutor always gets the full session duration
        sessionDurationSeconds = endUtc.difference(startUtc).inSeconds;
        print("👨‍🏫 Tutor timer: ${sessionDurationSeconds}s (full duration)");
      } else {
        // Student calculation
        if (actualIsActive) {
          // Session is active, calculate remaining time
          sessionDurationSeconds = endUtc.difference(now).inSeconds;
          print("👨‍🎓 Student timer: ${sessionDurationSeconds}s (remaining from $endUtc vs now $now)");
        } else {
          // Session not started yet, use full duration
          sessionDurationSeconds = endUtc.difference(startUtc).inSeconds;
          print("👨‍🎓 Student timer: ${sessionDurationSeconds}s (full duration)");
        }
      }
      
      // Ensure we have at least 60 seconds (1 minute)
      if (sessionDurationSeconds <= 0) {
        sessionDurationSeconds = 60; // Default to 1 minute if calculation fails
      }

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => VideoCallScreen(
                channelName: channelName,
                token: token,
                remainingSeconds: sessionDurationSeconds,
                sessionId: sessionId,
                languageId: languageId,
                levelId: levelId,
                isGroupSession: false, // Tutor-student sessions don't need group session logic (like leaveSession)
              ),
        ),
      );
      
      // Refresh sessions if video call returned true (session was completed)
      if (result == true && onSessionCompleted != null) {
        onSessionCompleted!();
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error joining session: $err")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          // Navigate to details screen
           Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SessionDetailsScreen(
                session: BookedSession(
                  id: sessionId,
                  channelName: channelName,
                  language: sessionTitle.split('(')[0].trim(), // Approximate
                  languageId: languageId,
                  level: sessionTitle.split('(')[1].replaceAll(')', '').trim(), // Approximate
                  levelId: levelId,
                  date: DateTime.parse(date), // This might need better parsing if date is just string
                  startTime: startTime, // Use actual start time
                  endTime: endTime,
                  userName: name,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  note: note,
                  userImageUrl: imageUrl,
                ),
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              UserAvatar(
                radius: 32,
                imageUrl: imageUrl,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
  
              // Expanded middle content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sessionTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
  
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Builder(
                  builder: (context) {
                    final String role = AuthService().user!.role;
  
                    String buttonText;
                    bool isEnabled = false;
  
                    if (role == 'Tutor') {
                      buttonText = "Start";
                      
                      // Parse the date string to DateTime
                      final sessionDate = DateTime.parse(date);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final sessionDay = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
                      
                      // Enable if session is today
                      isEnabled = today == sessionDay;
                    } else if (role == 'Student') {
                      buttonText = "Join";
                      isEnabled = isActive; // Student can only join if active
                    } else {
                      buttonText = "Join";
                    }
  
                    return ElevatedButton.icon(
                      onPressed:
                          isEnabled
                              ? () {
                                joinChannel(context);
                              }
                              : null,
                      icon: const Icon(
                        Icons.video_call,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        buttonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        elevation: 2,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
