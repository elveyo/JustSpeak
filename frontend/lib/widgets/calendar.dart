import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar<T> extends StatefulWidget {
  final List<T> events;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? initialFocusedDay;
  final List<T> Function(DateTime day) getEventsForDay;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final Color? selectedColor;
  final Color? eventColor;

  const Calendar({
    Key? key,
    required this.events,
    required this.firstDay,
    required this.lastDay,
    required this.getEventsForDay,
    this.onDaySelected,
    this.initialFocusedDay,
    this.selectedColor,
    this.eventColor,
  }) : super(key: key);

  @override
  State<Calendar<T>> createState() => _GenericCalendarState<T>();
}

class _GenericCalendarState<T> extends State<Calendar<T>> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<T>(
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      focusedDay: _focusedDay,
      rowHeight: 35,
      headerStyle: const HeaderStyle(
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
        if (widget.onDaySelected != null) {
          widget.onDaySelected!(selectedDay, focusedDay);
        }
      },
      eventLoader: widget.getEventsForDay,
      calendarBuilders: CalendarBuilders<T>(
        defaultBuilder: (context, day, focusedDay) {
          final hasEvent = widget.getEventsForDay(day).isNotEmpty;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  isSameDay(day, _selectedDay)
                      ? (widget.selectedColor ??
                          Theme.of(context).colorScheme.secondary)
                      : hasEvent
                      ? (widget.eventColor ??
                          Theme.of(context).primaryColor.withOpacity(1))
                      : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
              border:
                  hasEvent
                      ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      )
                      : null,
            ),
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: hasEvent ? Colors.white : Colors.white70,
                fontWeight: hasEvent ? FontWeight.bold : FontWeight.normal,
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
    );
  }
}
