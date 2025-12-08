import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/user_avatar.dart';

class SessionDetailsScreen extends StatefulWidget {
  final BookedSession session;

  const SessionDetailsScreen({super.key, required this.session});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  late BookedSession _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _fetchLatestSessionData();
  }

  Future<void> _fetchLatestSessionData() async {
    try {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      final role = AuthService().user!.role;
      
      final sessions = role == "Tutor" 
          ? await sessionProvider.getTutorSessions()
          : await sessionProvider.getStudentSessions();
      
      final updatedSession = sessions.firstWhere(
        (s) => s.id == widget.session.id,
        orElse: () => widget.session,
      );

      if (mounted) {
        setState(() {
          _session = updatedSession;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching session details: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with User Info
            Center(
              child: Column(
                children: [
                  UserAvatar(
                    radius: 50,
                    imageUrl: _session.userImageUrl,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _session.userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _session.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _session.isCompleted ? Colors.green : Colors.blue,
                      ),
                    ),
                    child: Text(
                      _session.isCompleted ? "Completed" : "Scheduled",
                      style: TextStyle(
                        color: _session.isCompleted ? Colors.green : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Session Info Cards
            _buildInfoCard(
              context,
              icon: Icons.language,
              title: "Language",
              value: "${_session.language} (${_session.level})",
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              icon: Icons.calendar_today,
              title: "Date & Time",
              value:
                  "${dateFormat.format(_session.startTime)}\n${timeFormat.format(_session.startTime)} - ${timeFormat.format(_session.endTime)}",
            ),
            
            if (_session.note != null && _session.note!.isNotEmpty) ...[
              const SizedBox(height: 32),
              const Text(
                "Tutor's Note",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  _session.note!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
