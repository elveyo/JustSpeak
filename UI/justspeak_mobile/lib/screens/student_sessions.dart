import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/widgets/session_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/layouts/master_screen.dart';
import 'package:intl/intl.dart';

class StudentSessionsScreen extends StatefulWidget {
  const StudentSessionsScreen({Key? key}) : super(key: key);

  @override
  _StudentSessionsScreenState createState() => _StudentSessionsScreenState();
}

class _StudentSessionsScreenState extends State<StudentSessionsScreen> {
  List<BookedSession>? _bookedSessions;

  @override
  void initState() {
    super.initState();
    _getStudentSessions();
  }

  Future<void> _getStudentSessions() async {
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );

    try {
      final bookedSessions = await sessionProvider.getStudentSessions();

      setState(() {
        _bookedSessions = bookedSessions;
      });
    } catch (error) {
      print("Error fetching sessions: $error");
    }
  }

  // Helper to group sessions by date
  Map<DateTime, List<BookedSession>> _groupSessionsByDate(
    List<BookedSession> sessions,
  ) {
    Map<DateTime, List<BookedSession>> grouped = {};
    for (var session in sessions) {
      // Only use the date part (year, month, day)
      final date = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(session);
    }
    // Sort by date ascending
    final sortedKeys = grouped.keys.toList()..sort();
    Map<DateTime, List<BookedSession>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else if (date.year == today.year) {
      // Show "Monday, 5 June" for this year
      return DateFormat('EEEE, d MMMM').format(date);
    } else {
      // Show "Monday, 5 June 2023" for other years
      return DateFormat('EEEE, d MMMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Lessons',
      child: _bookedSessions == null
          ? const Center(child: CircularProgressIndicator())
          : _bookedSessions!.isEmpty
              ? const Center(
                  child: Text(
                    'You have no booked lessons.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._groupSessionsByDate(_bookedSessions!).entries.expand((
                        entry,
                      ) {
                        final date = entry.key;
                        final sessions = entry.value;
                        return [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              bottom: 8.0,
                              left: 4.0,
                            ),
                            child: Text(
                              _formatDateLabel(date),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          ...List.generate(sessions.length, (i) {
                            final session = sessions[i];
                            return Column(
                              children: [
                                SessionCard(
                                  sessionId: session.id,
                                  channelName: session.channelName,
                                  imageUrl: session.userImageUrl,
                                  name: session.userName,
                                  sessionTitle:
                                      '${session.language} (${session.level})',
                                  languageId: session.languageId,
                                  levelId: session.levelId,
                                  date: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(session.date),
                                  time:
                                      '${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')} - ${session.endTime.hour.toString().padLeft(2, '0')}:${session.endTime.minute.toString().padLeft(2, '0')}',
                                  isActive: session.isActive,
                                  endTime: session.endTime,
                                  isCompleted: session.isCompleted,
                                  note: session.note,
                                ),
                                if (i != sessions.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            );
                          }),
                        ];
                      }),
                    ],
                  ),
                ),
    );
  }
}
