import 'package:flutter/material.dart';
import 'package:frontend/models/booked_session.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/widgets/session_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/layouts/master_screen.dart';

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
      // opcionalno: prikazi error
      print("Error fetching sessions: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'My Lessons',
      child:
          _bookedSessions == null
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
                  children: [
                    for (int i = 0; i < _bookedSessions!.length; i++) ...[
                      // Print imageUrl to console
                      (() {
                        print(_bookedSessions![i].toJson());
                        return const SizedBox.shrink();
                      })(),
                      SessionCard(
                        imageUrl: _bookedSessions![i].userImageUrl,
                        name: _bookedSessions![i].userName,
                        sessionTitle:
                            '${_bookedSessions![i].language} (${_bookedSessions![i].level})',
                        date: _bookedSessions![i].date
                            .toIso8601String()
                            .substring(0, 10),
                        time:
                            '${_bookedSessions![i].startTime.hour.toString().padLeft(2, '0')}:${_bookedSessions![i].startTime.minute.toString().padLeft(2, '0')} - ${_bookedSessions![i].endTime.hour.toString().padLeft(2, '0')}:${_bookedSessions![i].endTime.minute.toString().padLeft(2, '0')}',
                      ),
                      if (i != _bookedSessions!.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
    );
  }
}
