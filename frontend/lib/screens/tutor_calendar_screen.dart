import 'package:flutter/material.dart';
import 'package:frontend/models/calendar_slot.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/widgets/session_card.dart';
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

  late final Schedule schedule;
  Map<DateTime, List<CalendarSlot>> slotsByDate = {};

  @override
  void initState() {
    super.initState();
    schedule = Schedule(
      tutorId: 1,
      duration: 30,
      price: 20.0,
      slots: [
        CalendarSlot(
          start: DateTime.now().add(const Duration(hours: 2)),
          end: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
          isBooked: false,
        ),
        CalendarSlot(
          start: DateTime.now().add(const Duration(days: 1, hours: 3)),
          end: DateTime.now().add(
            const Duration(days: 1, hours: 3, minutes: 30),
          ),
          isBooked: true,
        ),
        CalendarSlot(
          start: DateTime.now().add(const Duration(days: 2, hours: 4)),
          end: DateTime.now().add(
            const Duration(days: 2, hours: 4, minutes: 30),
          ),
          isBooked: false,
        ),
      ],
    );
    _groupSlotsByDate();
  }

  void _groupSlotsByDate() {
    slotsByDate.clear();
    for (var slot in schedule.slots) {
      final date = DateTime(slot.start.year, slot.start.month, slot.start.day);
      if (!slotsByDate.containsKey(date)) {
        slotsByDate[date] = <CalendarSlot>[];
      }
      slotsByDate[date]!.add(slot);
    }
  }

  List<CalendarSlot> _getSlotsForDay(DateTime? day) {
    if (day == null) return <CalendarSlot>[];
    final date = DateTime(day.year, day.month, day.day);
    return slotsByDate[date] ?? <CalendarSlot>[];
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Calendar',
      child: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: _focusedDay,
              rowHeight: 35,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              selectedDayPredicate:
                  (day) => _selectedDay != null && isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedDay == null)
              const Center(child: Text('Select a day'))
            else
              Column(
                children: [
                  SessionCard(
                    imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
                    name: 'John Doe',
                    sessionTitle: 'Math Tutoring',
                    date: '2024-06-10',
                    time: '10:00 AM',
                  ),
                  const SizedBox(height: 12),
                  SessionCard(
                    imageUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
                    name: 'Jane Smith',
                    sessionTitle: 'Physics Session',
                    date: '2024-06-10',
                    time: '2:00 PM',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
