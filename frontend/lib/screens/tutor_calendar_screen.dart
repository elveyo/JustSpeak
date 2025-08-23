import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/models/calendar_slot.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/add_schedule_screen.dart';
import 'package:frontend/widgets/calendar.dart';
import 'package:frontend/widgets/session_card.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/layouts/master_screen.dart';

class TutorCalendarScreen extends StatefulWidget {
  const TutorCalendarScreen({Key? key}) : super(key: key);

  @override
  _TutorCalendarScreenState createState() => _TutorCalendarScreenState();
}

class _TutorCalendarScreenState extends State<TutorCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  List<BookedSession>? _bookedSessions;
  Schedule? tutorSchedule;

  @override
  void initState() {
    super.initState();
    _getTutorSessions();
  }

  Future<void> _getTutorSessions() async {
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );

    try {
      final bookedSessions = await sessionProvider.getTutorSessions();

      setState(() {
        _bookedSessions = bookedSessions;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Calendar',
      child: FutureBuilder<void>(
        future: _bookedSessions == [] ? _getTutorSessions() : null,
        builder: (context, snapshot) {
          if (_bookedSessions == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You need to set your schedule first.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ManageScheduleScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Set Schedule",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Helper: group sessions by date (yyyy-MM-dd)
          Map<String, List<BookedSession>> sessionsByDate = {};
          for (var session in _bookedSessions!) {
            final dateKey = session.date.toIso8601String().substring(0, 10);
            sessionsByDate.putIfAbsent(dateKey, () => []).add(session);
          }

          // Helper: get events for a given day
          List<BookedSession> _getSessionsForDay(DateTime day) {
            final key = day.toIso8601String().substring(0, 10);
            return sessionsByDate[key] ?? [];
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Calendar<BookedSession>(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  initialFocusedDay: _focusedDay,
                  events: _bookedSessions!, // lista svih booked sesija
                  getEventsForDay: _getSessionsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  eventColor: Theme.of(context).primaryColor,
                ),

                const SizedBox(height: 20),
                if (_selectedDay == null)
                  const Center(child: Text('Select a day'))
                else
                  Builder(
                    builder: (context) {
                      final sessions = _getSessionsForDay(_selectedDay!);
                      if (sessions.isEmpty) {
                        return const Center(
                          child: Text('No sessions for this day'),
                        );
                      }
                      return Column(
                        children: [
                          for (int i = 0; i < sessions.length; i++) ...[
                            SessionCard(
                              imageUrl: sessions[i].userImageUrl,
                              name: sessions[i].userName,
                              sessionTitle:
                                  '${sessions[i].language} (${sessions[i].level})',
                              date: sessions[i].date
                                  .toIso8601String()
                                  .substring(0, 10),
                              time:
                                  '${sessions[i].startTime.hour.toString().padLeft(2, '0')}:${sessions[i].startTime.minute.toString().padLeft(2, '0')} - ${sessions[i].endTime.hour.toString().padLeft(2, '0')}:${sessions[i].endTime.minute.toString().padLeft(2, '0')}',
                            ),
                            if (i != sessions.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
