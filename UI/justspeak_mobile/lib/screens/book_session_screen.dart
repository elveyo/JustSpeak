import 'package:flutter/material.dart';
import 'package:frontend/models/calendar_slot.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/level.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/language_level_provider.dart';
import 'package:frontend/providers/language_provider.dart';
import 'package:frontend/providers/payment_provider.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/providers/session_provider.dart';
import 'package:frontend/screens/student_sessions.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/calendar.dart';
import 'package:provider/provider.dart';

class TutorBookingScreen extends StatefulWidget {
  final int tutorId;
  const TutorBookingScreen({Key? key, required this.tutorId}) : super(key: key);

  @override
  State<TutorBookingScreen> createState() => _TutorBookingScreenState();
}

class _TutorBookingScreenState extends State<TutorBookingScreen> with WidgetsBindingObserver {
  int? _selectedLanguage;
  int? _selectedLevel;
  String? _selectedSlot;

  List<Language>? _languages;
  List<Level>? _languageLevels;

  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Schedule? _schedule;
  Map<String, List<CalendarSlot>> slotsByDate = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getTutorSchedule();
    _loadLanguagesAndLevels();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh schedule when app comes back to foreground
      _getTutorSchedule();
    }
  }

  Future<void> _bookSession() async {
    print("Starting _bookSession");
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );

    try {
      print("Preparing request...");
      final price = _schedule!.price.toInt();
      final request = {
        "studentId": AuthService().user!.id,
        "tutorId": widget.tutorId,
        "languageId": _selectedLanguage,
        "levelId": _selectedLevel,
        "startTime": _selectedSlot,
        "price": price,
      };
      print("Request data: $request");
      
      print("Calling sessionProvider.bookSession...");
      var sessionId = await sessionProvider.bookSession(request);
      print("Session booked with ID: $sessionId");

      print("Initiating payment...");
      var paymentResult = await paymentProvider.payWithPaymentSheet(price);
      print("Payment result: ${paymentResult.success}");

      if (paymentResult.success) {
        var payment = {
          'sessionId': sessionId,
          'amount': price,
          'stripeTransactionId': paymentResult.stripeTransactionId,
        };

        print("Inserting payment record...");
        await paymentProvider.insert(payment);
        print("Payment inserted.");
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentSessionsScreen()),
        );
      } else {
        print("Payment failed: ${paymentResult.errorMessage}");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment failed: ${paymentResult.errorMessage}")),
        );
        // Optionally cancel booking here if payment is required
      }
    } catch (error) {
      print("Error in _bookSession: $error");
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Error"),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Ok"),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _getTutorSchedule() async {
    final scheduleProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );

    try {
      final schedule = await scheduleProvider.getSchedule(widget.tutorId);

      if (schedule != null) {
        // Clear existing slots
        slotsByDate.clear();
        for (var slot in schedule.slots) {
          if (slot.isBooked) continue;
          final dateKey = slot.date.toIso8601String().substring(0, 10);
          slotsByDate.putIfAbsent(dateKey, () => []).add(slot);
        }
      }

      if (mounted) {
        setState(() {
          _schedule = schedule;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // Helper: dobavi sve slotove za izabrani dan
  List<CalendarSlot> _getSlotsForDay(DateTime day) {
    final key = day.toIso8601String().substring(0, 10);
    return slotsByDate[key] ?? [];
  }

  Future<void> _loadLanguagesAndLevels() async {
    try {
      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      final languageLevelProvider = Provider.of<LanguageLevelProvider>(
        context,
        listen: false,
      );
      final langs = await languageProvider.get(
        filter: {"userId": widget.tutorId},
      );
      if (langs.items != null && langs.items!.isNotEmpty) {
        _selectedLanguage = langs.items!.first.id;
      } else {
        _selectedLanguage = null;
      }
      final levels = await languageLevelProvider.get(
        filter: {"userId": widget.tutorId, "languageId": _selectedLanguage},
      );

      setState(() {
        _languages = langs.items;
        _languageLevels = levels.items;
        if (levels.items != null && levels.items!.isNotEmpty) {
          _selectedLevel = levels.items!.first.id;
        } else {
          _selectedLevel = null;
        }
      });

      // After setting, load sessions for the new selection
    } catch (e) {
      // Optionally handle error, e.g. show a snackbar or log
    }
  }

  Future<void> _fetchLevelsByLanguage(int languageId) async {
    try {
      final languageLevelProvider = Provider.of<LanguageLevelProvider>(
        context,
        listen: false,
      );
      final levels = await languageLevelProvider.get(
        filter: {"userId": widget.tutorId, "languageId": _selectedLanguage},
      );
      setState(() {
        _languageLevels = levels.items;
        if (levels.items != null && levels.items!.isNotEmpty) {
          _selectedLevel = levels.items!.first.id;
        } else {
          _selectedLevel = null;
        }
      });
    } catch (e) {
      // Optionally handle error, e.g. show a snackbar or log
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _schedule == null
              ? const Center(child: CircularProgressIndicator())
              : (_schedule!.slots.isEmpty)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "Tutor has no available sessions",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB000FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "This tutor hasn't set up their schedule yet. Please check back later.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB000FF),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Go Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                onRefresh: () async {
                  await _getTutorSchedule();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12.0, 25.0, 12.0, 12.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BOOK SESSION',
                          style: TextStyle(
                            color: Color(0xFFB000FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFFB000FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value:
                          (_languages != null && _languages!.isNotEmpty)
                              ? _languages!.first.id
                              : null,
                      items:
                          (_languages ?? [])
                              .map(
                                (lang) => DropdownMenuItem(
                                  value: lang.id,
                                  child: Text(lang.name),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedLanguage = val!;
                        });
                        _fetchLevelsByLanguage(_selectedLanguage!);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, // Increased horizontal padding
                          vertical: 5, // Increased vertical padding
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Choose Level",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value:
                          (_languageLevels != null &&
                                  _languageLevels!.isNotEmpty)
                              ? _languageLevels!.first.id
                              : null,
                      items:
                          (_languageLevels ?? [])
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level.id,
                                  child: Text(level.name),
                                ),
                              )
                              .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedLevel = val!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Pick a Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Calendar(
                        events: [],
                        firstDay: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        initialFocusedDay: _focusedDay,
                        getEventsForDay: _getSlotsForDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        selectedColor: Colors.purple,
                        eventColor: Colors.purple.shade200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Available Slots",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          (_getSlotsForDay(_selectedDay!))
                              .map(
                                (slot) => GestureDetector(
                                  onTap:
                                      () => setState(
                                        () =>
                                            _selectedSlot =
                                                slot.start.toIso8601String(),
                                      ),
                                  child: _buildTimeChip(
                                    slot.start.toIso8601String(),
                                    _selectedSlot ==
                                        slot.start.toIso8601String(),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    // Rezime izbora
                    if (_selectedLanguage != null &&
                        _selectedLevel != null &&
                        _selectedDay != null &&
                        _selectedSlot != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.purple,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Reservation Summary",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(
                                  Icons.language,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Language: ${_languages?.firstWhere((lang) => lang.id == _selectedLanguage).name}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.school,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Language: ${_languageLevels?.firstWhere((lvl) => lvl.id == _selectedLevel).name}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Date: ${_selectedDay!.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Time: ${_selectedSlot != null && _selectedSlot!.length >= 16 ? _selectedSlot!.substring(11, 16) : ''}",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Price: ${_schedule!.price}\$",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (_selectedLanguage == null ||
                                    _selectedLevel == null ||
                                    _selectedSlot == null)
                                ? Colors.grey
                                : Colors.purple,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed:
                          (_selectedLanguage == null ||
                                  _selectedLevel == null ||
                                  _selectedSlot == null)
                              ? null
                              : _bookSession,
                      child: const Text(
                        "BOOK",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTimeChip(String isoLabel, bool isSelected) {
    // Expecting isoLabel to be in ISO format, e.g. "2024-06-08T14:30:00"
    String _formatTime(String iso) {
      try {
        final dateTime = DateTime.parse(iso);
        final hour = dateTime.hour.toString().padLeft(2, '0');
        final minute = dateTime.minute.toString().padLeft(2, '0');
        return '$hour:$minute';
      } catch (e) {
        return iso; // fallback to original if parsing fails
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatTime(isoLabel),
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
