import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/models/calendar_slot.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/session_provider.dart';
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
      for (var session in bookedSessions) {
        print(session.date);
      }
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
        future: _bookedSessions == null ? _getTutorSessions() : null,
        builder: (context, snapshot) {
          // Show loading indicator while fetching sessions
          if (_bookedSessions == null) {
            return const Center(child: CircularProgressIndicator());
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
                TableCalendar<BookedSession>(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _focusedDay,
                  rowHeight: 35,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  selectedDayPredicate:
                      (day) =>
                          _selectedDay != null && isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) => _getSessionsForDay(day),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final hasEvent = _getSessionsForDay(day).isNotEmpty;
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              isSameDay(day, _selectedDay)
                                  ? Theme.of(context).colorScheme.secondary
                                  : hasEvent
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(1)
                                  : Colors.grey.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border:
                              hasEvent
                                  ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  )
                                  : null,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            color: hasEvent ? Colors.white : Colors.white70,
                            fontWeight:
                                hasEvent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          bottom: 3,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
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
